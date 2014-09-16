class BugzillaDbAssociator
  include Sidekiq::Worker
  include ProcessSpawner
  include ApplicationMixin
  sidekiq_options :queue => :bugzilla_mirror, :retry => false

  def perform(bug_id_list)
    unless bug_id_list
      logger.info "No bugs specified for #{self.class}"
      return
    end
    logger.info "Updating the Issue Associations From #{bz_uri} ..."
    spawn_issue_processes(bug_id_list, BugzillaIssueAssociator)
  end
end
