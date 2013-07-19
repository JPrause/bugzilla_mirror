require 'yaml'

module ApplicationHelper

  BZ_CMD = '/usr/bin/bugzilla'
  BZ_COOKIES_FILE = File.expand_path('~') + '/.bugzillacookies'
  BZ_CREDS_FILE = File.expand_path('~') + '/bugzilla_credentials.yaml'

  # Ruby will catch and raise Erron::ENOENT: If there the user does  not
  # have a ~/bugzilla_credentials.yaml file.
  def bz_get_credentials
    begin
      creds = YAML.load_file(BZ_CREDS_FILE)
    rescue Errno::ENOENT => error
        raise "#{error.message}\n" +
          "Please create the YAML file:#{BZ_CREDS_FILE} with valid credentials." 
    end
    return creds[:bugzilla_credentials][:username],
      creds[:bugzilla_credentials][:password]
  end

  # Running "bugzilla login" generates the bugzilla cookies.
  # If that cookie file exists assume the user already logged in.
  def bz_logged_in?
    File.exists?(BZ_COOKIES_FILE)
  end

  def bz_login!
    raise "Please install python-bugzilla" unless
      File.exists?(File.expand_path(BZ_CMD))

    if not self.bz_logged_in?
      username, password = self.bz_get_credentials
      `#{BZ_CMD} login '#{username}' '#{password}'`
    end
  end                          

end
