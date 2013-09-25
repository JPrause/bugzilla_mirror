module ApplicationHelper

  def get_bugzilla_uri
    uri, _ = RubyBugzilla.options

    if uri.nil?
      "https://bugzilla.redhat.com/show_bug.cgi?id="
    else
      uri + "/show_bug.cgi?id="
    end
  end

end
