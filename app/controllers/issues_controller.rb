class IssuesController < ApplicationController
  # GET /issues
  # GET /issues.json
  def index
    @issues = Issue.all
    @issues_updated_at = Issue.order("updated_at ASC").last.nil? ?
      "None Found" : Issue.order("updated_at ASC").last.updated_at

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @issues }
    end
  end

  # GET /issues/update_all
  # GET /issues/update_all.json
  def update_all
    @issue_update_all_result = Issue.update_from_bz
  end

end
