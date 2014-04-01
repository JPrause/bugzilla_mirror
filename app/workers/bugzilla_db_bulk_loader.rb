require 'benchmark'

class BugzillaDbBulkLoader
  include Sidekiq::Worker
  include ProcessSpawner
  include ApplicationMixin
  sidekiq_options :queue => :cfme_bz, :retry => false

  PRIMARY_SET     = [:summary, :status]     # Required
  SECONDARY_SET   = [:assigned_to]
  ATTRS_IN_CHUNK  = [:flags]
  ATTR_CHUNK_SIZE = 4

  def required_set?(attr_list)
    attr_list.include?(:status)
  end

  def load_comments
    logger.info "Bulk loading comments in bulk ..."
    logger.info "We have #{@bug_ids.count} issues"

    logger.info "Fetching comments from #{bz_uri} ..."

    chunk_size  = bz_options["issues_per_client"] || 100
    chunks      = @bug_ids.each_slice(chunk_size).to_a
    chunks.each do |bug_id_list|

      logger.info "Fetch comments from #{bz_uri} for #{bug_id_list}"
      begin
        all_comments = {}
        time_taken = Benchmark.realtime do
          all_comments = @service.service.comments(:ids => bug_id_list)["bugs"]
        end
        logger.info "Took #{time_taken} seconds to fetch comments for #{bug_id_list.count} issues."
      rescue => e
        logger.error "Failed to fetch comments from #{bz_uri} - #{e}"
        next
      end

      logger.info "Now loading comments to the database ..."
      orig_logger_level = ActiveRecord::Base.logger.level
      time_taken = Benchmark.realtime do
        bug_id_list.each do |bug_id|

          bz_comments = ActiveBugzilla::Comment.instantiate_from_raw_data(all_comments[bug_id.to_s]["comments"])

          bug_hash = {:bug_id => bug_id}
          bug_hash[:comments] = bz_comments.collect { |c| Comment.object_to_presentable_hash(c) }

          ActiveRecord::Base.logger.level = Logger::INFO
          begin
            Bugzilla.bug_to_issue(bug_id, bug_hash, [:bug_id, :comments])
          rescue => e
            logger.error "Failed to load comments from #{bz_uri} for #{bug_id} to database - #{e}"
            next
          ensure
            ActiveRecord::Base.logger.level = orig_logger_level
          end
        end
      end
      logger.info "Took #{time_taken} seconds to load comments."
    end
    true
  end

  def load_associations
    bug_id_list = Issue.select(:bug_id).collect(&:bug_id)
    spawn_issue_processes(bug_id_list, BugzillaIssueAssociator)
  end

  def chunk_load_attrs(attr_list)
    chunk_size  = bz_options["issues_per_client"] || 100
    chunks = @bug_ids.each_slice(chunk_size).to_a

    logger.info "Loading the #{attr_list} attributes From #{bz_uri} in chunks of #{chunk_size} ..."

    attr_list.product(chunks) do |attr, bug_id_list|
      begin
        bugs = []
        logger.info "Fetching #{attr} for #{bug_id_list} ..."
        time_taken = Benchmark.realtime do
          bugs = ActiveBugzilla::Bug.find(:id => bug_id_list, :include_fields => [:id, attr])
        end
        logger.info "Took #{time_taken} seconds to fetch #{attr} for #{bug_id_list.count} issues."
      rescue => e
        logger.error "Failed to fetch #{attr} from #{bz_uri} - #{e}"
        next
      end

      logger.info "Loading #{attr} to the database ..."
      issue_attr_list   = [:bug_id, attr]
      orig_logger_level = ActiveRecord::Base.logger.level
      begin
        time_taken = Benchmark.realtime do
          bugs.each do |bug|
            bug_id    = bug.id
            bug_hash  = @service.fetch_issue(bug, issue_attr_list)

            ActiveRecord::Base.logger.level = Logger::INFO
            Bugzilla.bug_to_issue(bug_id, bug_hash, issue_attr_list)
            ActiveRecord::Base.logger.level = orig_logger_level
          end
        end
        logger.info "Completed Loading #{attr} in #{time_taken} seconds."
      rescue => e
        logger.error "Failed to load #{attr} to database - #{e}"
        next
      ensure
        ActiveRecord::Base.logger.level = orig_logger_level
      end
    end
  end

  def bulk_load_database
    logger.info "Loading the Database From #{bz_uri} ..."
    @service = Bugzilla.new
    begin
      bugs = []
      logger.info "Fetching List of Bug Id's for #{bz_product} ..."
      time_taken = Benchmark.realtime do
        bugs = ActiveBugzilla::Bug.find(:product => bz_product, :include_fields => [:id])
      end
      @bug_ids = bugs.collect(&:id)
      logger.info "Found #{@bug_ids.count} Issues for #{bz_product} in #{time_taken} seconds ..."
    rescue => e
      logger.error "Failed to fetch List of Bug Id's from #{bz_uri} - #{e}"
      return false
    end

    all_attrs   = Issue::ATTRIBUTES - [:bug_id] - ATTRS_IN_CHUNK
    rem_attrs   = all_attrs - PRIMARY_SET - SECONDARY_SET
    attr_chunks = [PRIMARY_SET] + [SECONDARY_SET] + rem_attrs.each_slice(ATTR_CHUNK_SIZE).to_a

    attr_chunks.each do |attr_list|

      issue_attr_list = [:bug_id] + attr_list
      attr_list = attr_list - [:bug_type] + [:type] if attr_list.include?(:bug_type)

      logger.info "Fetching #{attr_list} ..."
      begin
        bugs = []
        time_taken = Benchmark.realtime do
          bugs = ActiveBugzilla::Bug.find(:product => bz_product, :include_fields => [:id] + attr_list)
        end
        logger.info "Completed Fetching #{attr_list} in #{time_taken} seconds."
      rescue => e
        logger.error "Failed to fetch #{attr_list} from #{bz_uri} - #{e}"
        next unless required_set?(attr_list)
        logger.error "Aborting Bulk Load"
        return false
      end

      logger.info "Loading #{attr_list} to the database ..."
      orig_logger_level = ActiveRecord::Base.logger.level
      begin
        time_taken = Benchmark.realtime do
          bugs.each do |bug|
            bug_id    = bug.id
            bug_hash  = @service.fetch_issue(bug, issue_attr_list)

            ActiveRecord::Base.logger.level = Logger::INFO
            Bugzilla.bug_to_issue(bug_id, bug_hash, issue_attr_list)
            ActiveRecord::Base.logger.level = orig_logger_level
          end
        end
        logger.info "Completed Loading #{attr_list} in #{time_taken} seconds."
      rescue => e
        logger.error "Failed to load #{attr_list} to database - #{e}"
        next unless required_set?(attr_list)
        logger.error "Aborting Bulk Load"
        return false
      ensure
        ActiveRecord::Base.logger.level = orig_logger_level
      end
    end
    true
  end

  def perform
    if bulk_load_database
      chunk_load_attrs(ATTRS_IN_CHUNK)
      load_associations
      load_comments
      bz_update_config
    end
  end
end
