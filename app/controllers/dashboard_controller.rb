class DashboardController < ApplicationController
  protect_from_forgery
  #
  # Cfme Bz Web Interface (Html)
  #
  def index
    @selected_owner  = params['selected_owner']  || @selected_owner  || "All"
    @selected_status = params['selected_status'] || @selected_status || ["ON_DEV"]
    @issues = Issue.order(sort_column + " " + sort_direction)
    @issues = @issues.where(:assigned_to => @selected_owner)  if @selected_owner  != "All"
    @issues = @issues.where(:status      => @selected_status) if @selected_status != ["All"]
    @issues_updated_at = Issue.order("updated_at ASC").last.nil? ? "None Found" :
      Issue.order("updated_at ASC").last.updated_at

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def reload_issues
    WorkerManager.reload_database_from_bugzilla
  end

  def update_issues
    WorkerManager.update_database_from_bugzilla
  end

  def view_issue
    @bug_id = params['id']
    @issue  = Issue.where(:bug_id => @bug_id).first
  end

  def refresh_issue
    @bug_id = params['id']
    WorkerManager.update_issues_from_bugzilla([@bug_id])
    view_issue
    render :action => 'view_issue'
  end
end
