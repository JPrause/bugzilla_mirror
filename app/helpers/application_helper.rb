require 'yaml'

module ApplicationHelper

  # Ruby will catch and raise Erron::ENOENT: If there the user does  not
  # have a ~/bugzilla_credentials.yaml file.
  def get_bugzilla_creds
    creds_file = File.expand_path('~') + '/bugzilla_credentials.yaml'

    begin
      creds = YAML.load_file(creds_file)
    rescue Errno::ENOENT => error
        raise "#{error.message}\n" +
          "Please create the YAML file:#{creds_file} with valid credentials." 
    end
    return creds[:bugzilla_credentials][:username],
      creds[:bugzilla_credentials][:password]
  end

  # Running "bugzilla login" generates the file ~/.bugzillacookies
  # If that file exists assume the user already logged in.
  def logged_in?
    File.exists?(File.expand_path('~') + '/.bugzillacookies')
  end

  def login!
    raise "Please install python-bugzilla" unless
      File.exists?(File.expand_path('/usr/bin/bugzilla'))

    username, password = self.get_bugzilla_creds
    login_cmd = "/usr/bin/bugzilla login " \
                "\'#{username}\' " \
                "\'#{password}\' "
    %x[ #{login_cmd} ]         
  end                          

end
