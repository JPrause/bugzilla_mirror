class BugzillaIssueLoader
  include Sidekiq::Worker
  include ApplicationMixin
  sidekiq_options :queue => :bugzilla_mirror, :retry => false

  def load_issues(bug_id_list)
    request_count = bug_id_list.count
    logger.info "Loading #{request_count} Issues: #{bug_id_list} ..."

    @service = Bugzilla.new
    issue_attrs = Issue::ATTRIBUTES.dup | [:comments]

    bugs = @service.fetch_issues(bug_id_list, issue_attrs)
    valid = 0
    bugs.each do |bug|
      next if bug.blank?
      bug_id = bug[:bug_id]
      begin
        Bugzilla.bug_to_issue(bug_id, bug, issue_attrs)
      rescue => e
        logger.error "Failed to Load Issue #{bug_id} from #{bz_uri} - #{e}"
        backtrace = e.backtrace.join("\n")
        logger.error "Stack Trace: #{backtrace}"
        next
      end
      valid += 1
    end
    request_count - valid
  end

  def perform(bug_id_list = nil)
    unless bug_id_list
      logger.info "No bugs specified for #{self.class} ..."
      return
    end
    load_issues(bug_id_list)
  end
end
