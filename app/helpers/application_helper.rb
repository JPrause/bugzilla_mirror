module ApplicationHelper

  def get_bugzilla_uri
    uri, _ = BzCommand.options
    uri + "/show_bug.cgi?id="
  end

end
