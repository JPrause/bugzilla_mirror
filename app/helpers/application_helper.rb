module ApplicationHelper

  def get_bugzilla_uri
    uri, _ = RubyBugzilla.options
    uri + "/show_bug.cgi?id="
  end

end
