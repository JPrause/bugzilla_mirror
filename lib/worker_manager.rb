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
    bug_id_list = Issue.select(:bug_id).collect(&:bug_id)
    BugzillaDbAssociator.perform_async(bug_id_list)
  end

  def self.running?(klass)
    Sidekiq::Workers.new.each do |name, work, started|
      return true if started.fetch_path('payload', 'class') == klass.to_s
    end
    false
  end
end
