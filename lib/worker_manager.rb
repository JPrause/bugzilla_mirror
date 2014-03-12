require 'sidekiq'

class WorkerManager
  def self.options
    @options ||= YAML.load_file(Rails.root.join("config", "cfme_bz.yml"))[Rails.env]["bugzilla"]
  end

  def self.timestamp_path
    Rails.root.join(options["last_updated_file"])
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

  def self.update_bugzilla_timestamp
    File.open(timestamp_path, "w") { |fd| fd.write(DateTime.now.to_s) }
  end

  def self.fetch_bugzilla_timestamp
    return unless File.file?(timestamp_path)
    File.open(timestamp_path, "r") { |fd| fd.gets }
  end

  def self.running?(klass)
    Sidekiq::Workers.new.each do |name, work, started|
      return true if work['payload']['class'] == klass.to_s
    end
    false
  end
end
