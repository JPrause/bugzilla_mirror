module ApplicationHelper

  def get_bugzilla_uri
    AppConfig['bugzilla']['uri'] + "/show_bug.cgi?id="
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end

end
