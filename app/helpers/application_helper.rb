require 'yaml'

module ApplicationHelper
  def app_options
    @options ||= YAML.load_file(Rails.root.join('config', 'cfme_bz.yml'))[Rails.env]
  end

  def bz_options
    app_options['bugzilla']
  end

  def bz_uri
    bz_options['uri']
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction, :flag_version => params[:flag_version], :selected_owner => @selected_owner, :selected_status => @selected_status
  end

  def url_to_bugzilla(bug_id)
    "#{bz_options['uri']}#{bz_options['show_bug_prefix']}#{bug_id}"
  end

  def link_to_bugzilla(bug_id)
    link_to(bug_id, url_to_bugzilla(bug_id))
  end

  def ids_list(bug_ids)
    return [] if bug_ids.blank?
    bug_ids.is_a?(Array) ? bug_ids : bug_ids.split(" ")
  end

  def link_to_bugzillas(bug_ids)
    bug_id_list = ids_list(bug_ids)
    bug_id_list.collect do |bug_id|
      link_to_bugzilla(bug_id)
    end.join(" ").html_safe
  end

  def list_last_commit(bz)
    depends_on_commits = Issue.where(:bug_id => bz.depends_on_ids).collect { |i| i.commits.all }.flatten
    commits = bz.commits.all | depends_on_commits
    hash = commits.each_with_object(Hash.new(0)) do |c, inner_hash|
      inner_hash[c.branch] += 1
    end

    # TODO: Cleanup this formatting and double looping...
    string = ""
    hash.each do |k, v|
      string << "#{k}: #{v}\n"
    end

    string
  end

  def available_issue_states
    ["All"].concat(Issue.pluck(:status).uniq)
  end

  def available_issue_assigned_to
    ["All"].concat(Issue.pluck(:assigned_to).uniq)
  end

  #
  # Flag helper procs
  #
  def available_flag_versions
    flag_versions = ["All"].concat(Issue.pluck(:flags).uniq.collect { |k| get_flag_version(k) })
    flag_versions.uniq
  end

  def get_flag_version(flag_str)
    get_flag_name(flag_str, "version")
  end

  def get_flag_ack(flag_str, what)
    get_flag_value(flag_str, "#{what}_ack")
  end

  def get_flag_name(flag_str, what)
    entry = get_from_flags(flag_str)[what.to_sym]
    entry.blank? ? "NONE" : entry[:name]
  end

  def get_flag_value(flag_str, what)
    entry = get_from_flags(flag_str)[what.to_sym]
    entry.blank? ? "+" : entry[:value]
  end

  def get_from_flags(flag_str)
    res = {}
    Bugzilla.flags_to_hash(flag_str).each do |flag, value|
      if /^cfme-.*$/.match(flag)
        res[:version] = {:name => flag, :value => value}
      else
        res[flag.to_sym] = {:name => flag, :value => value}
      end
    end
    res
  end

  #
  # Logging helper
  #
  def log_info(msg)
    Rails.logger.info("#{self.class.name}: #{msg}")
  end

  def log_debug(msg)
    Rails.logger.debug("#{self.class.name}: #{msg}")
  end

  def log_error(msg)
    Rails.logger.error("#{self.class.name}: #{msg}")
  end
end
