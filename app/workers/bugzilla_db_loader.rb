class BugzillaDbLoader
  include Sidekiq::Worker
  include ProcessSpawner
  include CFMEToolsServices::SidekiqWorkerMixin
  include ApplicationMixin
  sidekiq_options :queue => :cfme_bz, :retry => false

  def load_database
    logger.info "Loading the Database From #{bz_uri} ..."
    @service = Bugzilla.new
    begin
      bug_ids = @service.fetch_bug_ids
    rescue => e
      logger.info "Failed to fetch Issue Id's from #{bz_uri} - #{e}"
      return
    end
    spawn_issue_processes(bug_ids, BugzillaIssueLoader)
    spawn_issue_processes(bug_ids, BugzillaIssueAssociator)
  end

  def perform
    this_synctime = bz_timestamp
    load_database
    bz_update_config(this_synctime)
  end
end
