class BugzillaDbUpdater
  include Sidekiq::Worker
  include ProcessSpawner
  include ApplicationMixin
  sidekiq_options :queue => :cfme_bz, :retry => false

  def update_database
    logger.info "Updating the Database From #{bz_uri} ..."
    @service = Bugzilla.new
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
    bz_update_config
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
    if BugzillaConfig.fetch_synctime.blank?
      logger.info "Cannot run the #{self.class}, the Database Bulk Loader must be run first"
      return
    end
    update_database
  end
end
