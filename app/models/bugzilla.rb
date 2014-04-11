class Bugzilla
  include ApplicationHelper
  DEFAULT_TIMEOUT = 120

  def initialize(username = nil, password = nil)
    service(username, password)
  end

  def timeout
    bz_options["timeout"] || DEFAULT_TIMEOUT
  end

  def service(username = nil, password = nil)
    @service ||= begin
      user = username || bz_options["username"]
      pass = password || bz_options["password"]
      log_info "Service Initialization to #{bz_uri} as #{user}, timeout = #{timeout} ..."
      bz_service = ActiveBugzilla::Service.new(bz_uri, user, pass)
      ActiveBugzilla::Service.timeout = timeout
      ActiveBugzilla::Base.service    = bz_service
    end
  end

  def fetch_bug_ids(search_options = {})
    log_info "Querying list of #{bz_product} Issue Ids ..."
    search_parameters = {:product => bz_product, :include_fields => ['id']}
    search_parameters.merge!(search_options) unless search_options.blank?
    ActiveBugzilla::Bug.find(search_parameters).collect(&:id)
  end

  def normalize_bz_data(attr, data)
    @keep_as_is ||= Issue::ASSOCIATIONS.keys | [:comments]
    return data if data.nil? || @keep_as_is.include?(attr)
    return "" if data == "---"
    return data.compact.delete_if { |item| item == "---" }.join(", ") if data.kind_of?(Array)
    data
  end

  def fetch_issue(bug_ref, include_fields = [:id])
    return unless bug_ref
    if bug_ref.kind_of?(Integer)
      bug_list = ActiveBugzilla::Bug.find(:id => bug_ref)
      return if bug_list.blank?
      bug = bug_list.first
    else
      bug = bug_ref
    end
    bug_id   = bug.id
    fields   = include_fields.dup

    include_bug_type = fields.include?(:bug_type)
    include_comments = fields.include?(:comments)

    bug_type = bug.type if include_bug_type

    fields.delete(:bug_id)
    fields.delete(:bug_type)

    attr_hash = fields.each_with_object({}) do |key, res|
      res[key] = normalize_bz_data(key, bug.respond_to?(key) ? bug.send(key) : nil)
    end

    attr_hash[:bug_id]   = bug_id
    attr_hash[:bug_type] = normalize_bz_data(:bug_type, bug_type) if include_bug_type

    if include_comments && attr_hash[:comments]
      comments = attr_hash[:comments].collect do |comment|
        Comment.object_to_presentable_hash(comment)
      end
      attr_hash[:comments] = comments
    end
    attr_hash
  end

  def fetch_issues(bug_id_list, include_fields = [:id])
    return [] if bug_id_list.blank?
    log_info "Fetching #{bug_id_list} Issues ..."
    ActiveBugzilla::Bug.find(:id => bug_id_list, :include_fields => include_fields | [:id]).collect do |bug|
      fetch_issue(bug, include_fields)
    end
  end

  def update_issue(bug_id, attr_hash)
    bz_target  = service.bugzilla_uri
    log_info "Attempting to update #{bug_id} with #{attr_hash}"
    log_info("Targeting Bugzilla #{bz_target} as #{service.username} ...")
    keys = attr_hash.keys.collect(&:to_sym)
    keys |= [:id, :flags, :summary, :status, :assigned_to]
    keys |= [:comments] if attr_hash.key?("comment")
    begin
      bug_list = ActiveBugzilla::Bug.find(:id => bug_id)
    rescue StandardError => e
      emsg = e.message
      raise IssuesController::AuthenticationError, emsg if emsg.downcase.match("username")
      raise IssuesController::ServiceUnavailable, emsg
    end
    raise IssuesController::IssueNotFound, "Issue #{bug_id} Not Found in #{bz_target}" if bug_list.blank?
    bug = bug_list.first

    begin
      unless attr_hash["comment"].blank?
        comment      = attr_hash["comment"]
        private_flag = false
        case comment
        when Hash
          text = comment["text"] || ""
          private_flag = comment["private"] if comment.key?("private")
        else
          text = comment.dup
        end
        text = text.strip
        log_warn("Ignoring blank comment specified") if text.blank?
        bug.add_comment(text, private_flag)      unless text.blank?
      end

      unless attr_hash["flags"].blank?
        flags_hash = attr_hash["flags"]
        flags_hash.each do |flag, value|
          value.blank? ?  bug.flags.delete(flag) : bug.flags[flag] = value
        end
      end

      %w(flags comment).each { |key| attr_hash.delete(key) }

      attr_hash.each { |key, value| bug.send("#{key}=", value) }
      bug.save
    rescue StandardError => e
      emsg = e.message
      raise IssuesController::AuthenticationError, emsg if emsg.downcase.match("username")
      raise IssuesController::ProcessingError, emsg
    end
    fetch_issue(bug, keys)
  end

  def self.bug_to_issue(bug_id, bug_hash, issue_attrs)
    return if bug_hash.size == 0
    issue_hash = bug_hash.dup
    flags      = issue_hash[:flags]
    comments   = issue_hash[:comments]
    [:id, :bug_id, :flags, :comments].each { |key| issue_hash.delete(key) }

    issue_hash[:bug_id]    = bug_id
    if issue_attrs.include?(:flags) && flags
      issue_hash[:flag_hash] = flags
      issue_attrs += [:flag_hash]
    end

    issue = Issue.find_by_bug_id(bug_id)
    if issue.blank?
      issue = Issue.create(issue_hash.slice(*issue_attrs))
    else
      issue.update_attributes(issue_hash.slice(*issue_attrs))
    end
    issue.comments = comments.collect { |c| Comment.new(c) } if comments
  end
end
