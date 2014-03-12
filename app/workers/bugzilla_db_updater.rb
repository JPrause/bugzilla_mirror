class BugzillaDbUpdater
  include Sidekiq::Worker
  include BugzillaHelper
  include ApplicationHelper
  sidekiq_options :queue => :cfme_bz, :retry => false

  def update_database
    logger.info "Updating the Database From #{bz_uri} ..."
    @service = Bugzilla.new
    bz_timestamp      = WorkerManager.fetch_bugzilla_timestamp
    search_parameters = {:updated_on => bz_timestamp} if bz_timestamp
    begin
      bug_ids = @service.fetch_bug_ids(search_parameters)
    rescue StandardError => e
      logger.info "Failed to fetch Issue Id's from #{bz_uri} - #{e}"
      return
    end
    if bug_ids.count == 0
      logger.info "No Issues found to get updated"
    else
      spawn_issue_processes(bug_ids, BugzillaIssueLoader)
      spawn_issue_processes(bug_ids, BugzillaIssueAssociator)
    end
    WorkerManager.update_bugzilla_timestamp
  end

  def perform
    if WorkerManager.running?(BugzillaDbLoader)
      logger.info "Cannot run the #{self.class} while the Database Loader is running"
      return
    end
    if WorkerManager.running?(BugzillaDbBulkLoader)
      logger.info "Cannot run the #{self.class} while the Database Bulk Loader is running"
      return
    end
    update_database
  end
end
