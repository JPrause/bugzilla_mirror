class BugzillaIssueAssociator
  include Sidekiq::Worker
  include ApplicationHelper
  sidekiq_options :queue => :cfme_bz, :retry => false

  def define_issue_association(this_issue, what, other_issues)
    this_issue.send(what).clear
    unless other_issues.blank?
      Array(other_issues).each do |other_id|
        other_issue = Issue.where(:bug_id => other_id).first
        logger.info "Associating #{this_issue.bug_id} <#{what}> #{other_id}"
        next if other_issue.blank?
        logger.info "#{this_issue.bug_id} <#{what}> #{other_id}"
        this_issue.send(what) << other_issue
      end
    end
  end

  def define_issue_associations(bug_id, bug_hash)
    return if bug_id.blank?
    this_issue = Issue.where(:bug_id => bug_id).first
    return if this_issue.blank?

    if bug_hash.key?(:depends_on)
      define_issue_association(this_issue,
                               Issue::ASSOCIATIONS[:depends_on],
                               bug_hash[:depends_on])
    end

    if bug_hash.key?(:blocks)
      define_issue_association(this_issue,
                               Issue::ASSOCIATIONS[:blocks],
                               bug_hash[:blocks])
    end

    if bug_hash.key?(:duplicate_id)
      define_issue_association(this_issue,
                               Issue::ASSOCIATIONS[:duplicate_id],
                               bug_hash[:duplicate_id])
    end
  end

  def define_associations(bug_id_list)
    request_count = bug_id_list.count
    logger.info "Requesting Associations for #{request_count} Issues: #{bug_id_list} ..."

    @service = Bugzilla.new
    association_attrs = Issue::ASSOCIATIONS.keys.dup

    bugs = @service.fetch_issues(bug_id_list, association_attrs)

    valid = 0
    bugs.each do |bug|
      next if bug.blank?
      bug_id = bug[:bug_id]
      begin
        define_issue_associations(bug_id, bug)
      rescue StandardError => e
        logger.error "Failed to Define Association for Issue #{bug_id} - #{e}"
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
    define_associations(bug_id_list)
  end
end
