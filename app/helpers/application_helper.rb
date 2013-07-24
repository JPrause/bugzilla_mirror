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
          "Please create file: #{BZ_CREDS_FILE} with valid credentials."
    end
    if creds[:bugzilla_credentials][:username].nil? ||
      creds[:bugzilla_credentials][:password].nil? then
      raise "Missing username or password in file: #{BZ_CREDS_FILE}."
    end

    [creds[:bugzilla_credentials][:username],
      creds[:bugzilla_credentials][:password]]
  end

  def bz_get_options
    begin
      options = YAML.load_file(BZ_CREDS_FILE)
    rescue Errno::ENOENT => error
      return nil
    end
    [options[:bugzilla_options][:bugzilla_uri],
      options[:bugzilla_options][:debug]]
  end


  # Running "bugzilla login" generates the bugzilla cookies.
  # If that cookie file exists assume the user already logged in.
  def bz_logged_in?
    File.exists?(BZ_COOKIES_FILE)
  end

  def bz_clear_login!
    if File.exists?(BZ_COOKIES_FILE) then
      File.delete(BZ_COOKIES_FILE)
    end
  end

  def bz_login!
    raise "Please install python-bugzilla" unless
      File.exists?(File.expand_path(BZ_CMD))

    if not self.bz_logged_in?
      username, password = self.bz_get_credentials
      uri_opt, debug_opt = self.bz_get_options

      login_cmd = "#{BZ_CMD} "
      login_cmd << "--bugzilla=#{uri_opt}/xmlrpc.cgi " unless uri_opt.nil?
      login_cmd << "--debug " unless debug_opt.nil?
      login_cmd << "login #{username} #{password}"

      login_cmd_no_pw = login_cmd.sub(password, '****')
      logger.debug "Running command: #{login_cmd_no_pw}"
      login_cmd_result =
        IO.popen(login_cmd.split(" ") << {:err=>[:child, :out]}) do |io_cmd|
          io_cmd.read
      end
      if not $?.success?
        # A failed login attempt could result in a corrupt BZ_COOKIES_FILE
        bz_clear_login!
        raise "#{login_cmd_no_pw} Failed.\n #{login_cmd_result}"
      end
    end
  end

end
