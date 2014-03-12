class IssuesController < ApplicationController
  class AuthenticationError       < StandardError; end
  class BadRequestError           < StandardError; end
  class UnsupportedMediaTypeError < StandardError; end
  class ProcessingError           < StandardError; end
  class ServiceUnavailable        < StandardError; end

  include RequestParser
  include Authenticator
  include ErrorHandler
  include RequestManager
  include ResponseGenerator

  RETURN_CODES = {
    :bad_request            => 400,
    :unauthorized           => 401,
    :forbidden              => 403,
    :not_found              => 404,
    :unsupported_media_type => 415,
    :internal_server_error  => 500,
    :service_unavailable    => 503
  }

  # Order *Must* be from most generic to most specific
  ERROR_MAPPING = {
    StandardError                               => :internal_server_error,
    NoMethodError                               => :internal_server_error,
    ActiveRecord::RecordNotFound                => :not_found,
    ActiveRecord::StatementInvalid              => :bad_request,
    JSON::ParserError                           => :bad_request,
    MultiJson::LoadError                        => :bad_request,
    IssuesController::AuthenticationError       => :unauthorized,
    IssuesController::BadRequestError           => :bad_request,
    IssuesController::UnsupportedMediaTypeError => :unsupported_media_type,
    IssuesController::ServiceUnavailable        => :service_unavailable,
    IssuesController::ProcessingError           => :internal_server_error
  }

  respond_to  :json
  rescue_from_api_errors

  #
  # Cfme Bz REST API (Json)
  #
  def show
    init_request
    log_info "Issue Get Request: params=#{params}"
    result = response_to_hash(generate_response)
    respond_to do |format|
      format.json { render :json => result }
    end
  end

  def update
    init_request
    log_info "Issue Post Request: params=#{params}"
    result = response_to_hash(update_issues)
    respond_to do |format|
      format.json { render :json => result }
    end
  end

  def refresh
    init_request
    log_info "Issue Refresh Request: params=#{params}"
    result = response_to_hash(refresh_issue)
    if result.blank?
      render_accepted_response
    else
      render :json => result
    end
  end

  private

  def init_request
    parse_api_request
    authenticate_api_request
    validate_response_format
  end
end
