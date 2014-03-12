class BugzillaDbLoader
  include Sidekiq::Worker
  include BugzillaHelper
  include ApplicationHelper
  sidekiq_options :queue => :cfme_bz, :retry => false

  def load_database
    logger.info "Loading the Database From #{bz_uri} ..."
    @service = Bugzilla.new
    begin
      bug_ids = @service.fetch_bug_ids
    rescue StandardError => e
      logger.info "Failed to fetch Issue Id's from #{bz_uri} - #{e}"
      return
    end
    spawn_issue_processes(bug_ids, BugzillaIssueLoader)
    spawn_issue_processes(bug_ids, BugzillaIssueAssociator)
  end

  def perform
    load_database
    WorkerManager.update_bugzilla_timestamp
  end
end
