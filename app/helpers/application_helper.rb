module ApplicationHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end

  def url_to_bugzilla(bz_id)
    link_to( bz_id, "#{AppConfig['bugzilla']['bug_display_uri']}#{bz_id}")
  end
     
  def url_to_depends_ons(dep_ids)
    dep_ids.collect { |dep_id|
      link_to(dep_id, "#{AppConfig['bugzilla']['bug_display_uri']}#{dep_id}")
    }.join(" ")
  end
     
end
