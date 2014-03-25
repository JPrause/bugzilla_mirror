class BugzillaIssueUpdater
  include Sidekiq::Worker
  include ProcessSpawner
  include ApplicationMixin
  sidekiq_options :queue => :cfme_bz, :retry => false

  def update_issues(bug_id_list)
    logger.info "Updating #{bug_id_list} Issues From #{bz_uri} ..."
    spawn_issue_processes(bug_id_list, BugzillaIssueLoader)
    spawn_issue_processes(bug_id_list, BugzillaIssueAssociator)
  end

  def perform(bug_id_list = nil)
    if bug_id_list.blank?
      logger.info "No Issue Ids specified ..."
      return
    end
    update_issues([bug_id_list].flatten)
  end
end
