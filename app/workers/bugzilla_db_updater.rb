class BugzillaDbUpdater
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  include CFMEToolsServices::SidekiqWorkerMixin
  include ProcessSpawner
  include ApplicationMixin
  sidekiq_options :queue => :cfme_bz, :retry => false

  recurrence { minutely }

  def update_database
    logger.info "Updating the Database From #{bz_uri} ..."
    @service = Bugzilla.new
    this_synctime = bz_timestamp
    search_parameters = {:updated_on => BugzillaConfig.fetch_synctime}
    begin
      bug_ids = @service.fetch_bug_ids(search_parameters)
    rescue => e
      logger.info "Failed to fetch Issue Id's from #{bz_uri} - #{e}"
      return
    end
    if bug_ids.blank?
      logger.info "No Issues found to get updated"
    else
      spawn_issue_processes(bug_ids, BugzillaIssueLoader)
      spawn_issue_processes(bug_ids, BugzillaIssueAssociator)
    end
    bz_update_config(this_synctime)
  end

  def perform
    workers = self.workers

    if !first_unique_worker?(workers)
      logger.info "#{self.class} is still running, skipping"
    elsif BugzillaDbLoader.running?
      logger.info "Cannot run the #{self.class} while the Database Loader is running"
    elsif BugzillaDbBulkLoader.running?
      logger.info "Cannot run the #{self.class} while the Database Bulk Loader is running"
    elsif BugzillaConfig.fetch_synctime.blank?
      logger.info "Cannot run the #{self.class}, the Database Bulk Loader must be run first"
    else
      update_database
    end
  end
end
