module ApplicationHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end

  def url_to_bugzilla(bz_id)
    link_to( bz_id, "#{AppConfig['bugzilla']['bug_display_uri']}#{bz_id}")
  end
     
  def url_to_bugzillas(bz_ids)
    bz_ids = [bz_ids] unless bz_ids.is_a?(Array)
    bz_ids.collect { |bz_id|
      url_to_bugzilla(bz_id)
    }.join(" ").html_safe
  end
     
end
