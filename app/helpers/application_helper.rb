module ApplicationHelper

  def get_bugzilla_uri
    uri, _ = RubyBugzilla.options

    if uri.nil?
      "https://bugzilla.redhat.com/show_bug.cgi?id="
    else
      uri + "/show_bug.cgi?id="
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end

end
