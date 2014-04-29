require 'sidekiq'
include ApplicationMixin

class WorkerManager
  def self.options
    bz_options
  end

  def self.reload_database_from_bugzilla
    BugzillaDbBulkLoader.perform_async
  end

  def self.update_database_from_bugzilla
    BugzillaDbUpdater.perform_async
  end

  def self.update_issues_from_bugzilla(bug_id_list)
    BugzillaIssueUpdater.perform_async(bug_id_list)
  end

  def self.refresh_associations_from_bugzilla
    bug_id_list = Issue.pluck(:bug_id).compact
    BugzillaDbAssociator.perform_async(bug_id_list)
  end
end
