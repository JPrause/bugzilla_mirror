class BugzillaDbBulkLoader
  include Sidekiq::Worker
  include BugzillaHelper
  include ApplicationHelper
  sidekiq_options :queue => :cfme_bz, :retry => false

  PRIMARY_SET   = [:summary, :status]     # Required
  SECONDARY_SET = [:assigned_to, :flags]

  def required_set?(attr_list)
    attr_list.include?(:status)
  end

  def time_stamp
    Time.now
  end

  def time_diff_to_msec(diff)
    (diff * 1000).to_i
  end

  def load_comments
    logger.info "Bulk loading comments in bulk ..."
    bug_ids = Issue.select(:bug_id).collect(&:bug_id)
    logger.info "We have #{bug_ids.count} issues"

    logger.info "Fetching comments from #{bz_uri} ..."

    chunk_size  = bz_options["issues_per_client"] || 100
    chunks      = bug_ids.each_slice(chunk_size).to_a
    chunks.each do |bug_id_list|

      ts1 = time_stamp
      logger.info "Fetch comments from #{bz_uri} for #{bug_id_list}"
      begin
        all_comments = @service.bz_service.comments(:ids => bug_id_list)["bugs"]
      rescue StandardError => e
        logger.error "Failed to fetch comments from #{bz_uri} - #{e}"
        next
      end
      logger.info "Took #{time_diff_to_msec(time_stamp - ts1)} milli-seconds to fetch comments for #{bug_id_list.count} issues."
      logger.info "Now loading comments to the database ..."
      ts2 = time_stamp

      bug_id_list.each do |bug_id|
        bug_comments = all_comments[bug_id.to_s]["comments"]

        bug_hash = {:bug_id => bug_id}
        bz_comments = ActiveBugzilla::Comment.instantiate_from_raw_data(bug_comments)
        bug_hash[:comments] = bz_comments.collect do |bz_comment|
          Comment::ATTRIBUTES.each_with_object({}) do |key, hash|
            hash[key] = bz_comment.send(key)
          end
        end

        old_level = ActiveRecord::Base.logger.level
        begin
          ActiveRecord::Base.logger.level = Logger::INFO
          Bugzilla.bug_to_issue(bug_id, bug_hash, [:bug_id, :comments])
          ActiveRecord::Base.logger.level = old_level
        rescue StandardError => e
          logger.error "Failed to load comments from #{bz_uri} for #{bug_id} to database - #{e}"
          ActiveRecord::Base.logger.level = old_level
          next
        end
      end
      logger.info "Took #{time_diff_to_msec(time_stamp - ts2)} milli-seconds to load comments."
    end
    true
  end

  def load_associations
    bug_id_list = Issue.select(:bug_id).collect(&:bug_id)
    spawn_issue_processes(bug_id_list, BugzillaIssueAssociator)
  end

  def bulk_load_database
    logger.info "Loading the Database From #{bz_uri} ..."
    @service = Bugzilla.new

    all_attrs   = (Issue::ATTRIBUTES - [:bug_id]).dup
    rem_attrs   = all_attrs - PRIMARY_SET - SECONDARY_SET
    attr_chunks = [PRIMARY_SET] + [SECONDARY_SET] + rem_attrs.each_slice(4).to_a

    attr_chunks.each do |attr_list|

      issue_attr_list = [:bug_id] + attr_list
      attr_list = attr_list - [:bug_type] + [:type] if attr_list.include?(:bug_type)

      logger.info "Fetching #{attr_list} ..."
      ts1  = time_stamp
      begin
        bugs = ActiveBugzilla::Bug.find(:product => bz_options["product"], :include_fields => [:id] + attr_list)
      rescue StandardError => e
        logger.error "Failed to fetch #{attr_list} from #{bz_uri} - #{e}"
        next unless required_set?(attr_list)
        logger.error "Aborting Bulk Load"
        return false
      end
      logger.info "Completed Fetching #{attr_list} in #{time_diff_to_msec(time_stamp - ts1)} milli-seconds."

      logger.info "Loading #{attr_list} to the database ..."
      ts2  = time_stamp
      begin
        bugs.each do |bug|
          bug_id    = bug.id
          bug_hash  = @service.fetch_issue(bug, issue_attr_list)

          old_level = ActiveRecord::Base.logger.level
          ActiveRecord::Base.logger.level = Logger::INFO
          Bugzilla.bug_to_issue(bug_id, bug_hash, issue_attr_list)
          ActiveRecord::Base.logger.level = old_level
        end
      rescue StandardError => e
        logger.error "Failed to load #{attr_list} to database - #{e}"
        next unless required_set?(attr_list)
        logger.error "Aborting Bulk Load"
        return false
      end
      logger.info "Completed Loading #{attr_list} in #{time_diff_to_msec(time_stamp - ts2)} milli-seconds."
    end
    true
  end

  def perform
    if bulk_load_database
      load_associations
      load_comments
      WorkerManager.update_bugzilla_timestamp
    end
  end
end
