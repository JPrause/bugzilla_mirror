module ApplicationHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction, :version => params[:version]
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

  def list_last_commit(bz)
    puts "JJV -090- list_last_commit(#{bz.bz_id}, #{bz.dep_ids})"
    "5.2.0.37" # JJV Hard code for initial testing
  end
     
  def available_versions()
    result = Issue.uniq.pluck(:version) # JJV
     # JJV ["cfme-5.2", "cfme-5.1.z", "cfme-5.3", "cfme-4.0.z", "NONE", "cfme-5.0.z", "cfme-5.2.z"] 
    puts "JJV -070- available_versions() result ->#{result}<-"
    Issue.uniq.pluck(:version)
  end
     
end
