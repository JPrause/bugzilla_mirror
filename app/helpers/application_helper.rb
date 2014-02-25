module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction, :flag_version => params[:flag_version]
  end

  def url_to_bugzilla(bz_id)
    link_to(bz_id, "#{AppConfig['bugzilla']['bug_display_uri']}#{bz_id}")
  end

  def url_to_bugzillas(bz_ids)
    bz_ids = [bz_ids] unless bz_ids.is_a?(Array)
    bz_ids.collect do |bz_id|
      url_to_bugzilla(bz_id)
    end.join(" ").html_safe
  end

  def list_last_commit(bz)
    depends_on_commits = Issue.where(:bz_id => bz.depends_on_ids).collect { |i| i.commits.all }.flatten
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

  def available_flag_versions
    flag_versions = ["All"].concat(Issue.uniq.pluck(:flag_version).sort)
    flag_versions.zip(flag_versions) << "All"
  end
end
