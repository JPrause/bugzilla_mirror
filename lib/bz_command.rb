require 'yaml'

class BzCommand

  CMD = '/usr/bin/bugzilla'
  COOKIES_FILE = File.expand_path('~') + '/.bugzillacookies'
  CREDS_FILE = File.expand_path('~') + '/bugzilla_credentials.yaml'

  # Ruby will catch and raise Erron::ENOENT: If there the user does not
  # have a ~/bugzilla_credentials.yaml file.
  def self.credentials
    begin
      creds = YAML.load_file(CREDS_FILE)
    rescue Errno::ENOENT => error
      raise "#{error.message}\n" +
        "Please create file: #{CREDS_FILE} with valid credentials."
    end
    if creds[:bugzilla_credentials][:username].nil? ||
      creds[:bugzilla_credentials][:password].nil? then
      raise "Missing username or password in file: #{CREDS_FILE}."
    end

    [creds[:bugzilla_credentials][:username],
      creds[:bugzilla_credentials][:password]]
  end

  def self.options
    begin
      options = YAML.load_file(CREDS_FILE)
    rescue Errno::ENOENT => error
      return nil
    end
    [options[:bugzilla_options][:bugzilla_uri],
      options[:bugzilla_options][:debug]]
  end


  # Running "bugzilla login" generates the bugzilla cookies.
  # If that cookie file exists assume the user already logged in.
  def self.logged_in?
    File.exists?(COOKIES_FILE)
  end

  def self.clear_login!
    if File.exists?(COOKIES_FILE) then
      File.delete(COOKIES_FILE)
    end
  end

  def self.login!

    login_cmd = "#{CMD} "
    login_cmd_result = "Nothing Run"

    raise "Please install python-bugzilla" unless
      File.exists?(File.expand_path(CMD))

    unless self.logged_in?
      username, password = self.credentials
      uri_opt, debug_opt = self.options

      login_cmd << "--bugzilla=#{uri_opt}/xmlrpc.cgi " unless uri_opt.nil?
      login_cmd << "--debug " unless debug_opt.nil?
      login_cmd << "login #{username} #{password}"

      login_cmd_no_pw = login_cmd.sub(password, '****')
      login_cmd_result =
        IO.popen(login_cmd.split(" ") << {:err=>[:child, :out]}) do |io_cmd|
          io_cmd.read
      end
      unless $?.success?
        # A failed login attempt could result in a corrupt COOKIES_FILE
        clear_login!
        raise "#{login_cmd_no_pw} Failed.\n #{login_cmd_result}"
      end
    end
    [login_cmd_no_pw, login_cmd_result]
  end

  def self.query(product, flag=nil, bug_status=nil, output_format=nil)

    raise "Please install python-bugzilla" unless
      File.exists?(File.expand_path(CMD))

    raise "Please specify a product" unless not product.nil?

    query_cmd = ["#{CMD}", "query"]
    query_cmd << "--product=#{product}"
    query_cmd << "--flag=#{flag}" unless flag.nil?
    query_cmd << "--bug_status=#{bug_status}" unless bug_status.nil?
    query_cmd << "--outputformat=\'#{output_format}\'" unless
      output_format.nil?

    # Preserve query_cmd without the password for logging and diags.
    query_cmd_popen_err = query_cmd.dup
    query_cmd_popen_err << {:err=>[:child, :out]}
    query_cmd_out = ""
    query_cmd_result = IO.popen(query_cmd_popen_err) do |io_cmd|
      query_cmd_out << io_cmd.read
    end
    raise "#{query_cmd.join(" ")} Failed.\n #{query_cmd_result}" unless
      $?.success?

    [query_cmd.join(" "), query_cmd_out]
  end

end
