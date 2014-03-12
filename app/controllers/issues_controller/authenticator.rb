class IssuesController
  module Authenticator
    #
    # REST APIs Authenticator
    #
    # We only need to authenticate on POSTS/PUTs for attributes not requiring
    #
    def authenticate_api_request
      if @req[:method] == :get
        @auth_username = bz_options["username"]
        @auth_password = bz_options["password"]
        return
      end

      authenticate_or_request_with_http_basic('Administration') do |user, pass|
        @auth_username, @auth_password = authenticate_bugzilla_user(user, pass)
        raise AuthenticationError, "Invalid Bugzilla Credentials Specified" unless @auth_username
        return
      end
    end

    # For now, delaying check until actual access so we don't go over the wire twice for this.
    def authenticate_bugzilla_user(user, pass)
      [user, pass]
    end
  end
end
