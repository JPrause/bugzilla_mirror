class ApplicationController < ActionController::Base
  include ApplicationHelper

  helper_method :sort_column, :sort_direction

  private

  def sort_column
    Issue.column_names.include?(params[:sort]) ? params[:sort] : "status"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
