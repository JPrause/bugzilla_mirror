require 'ostruct'
require 'yaml'

unless Rails.env.test?
  AppConfig = YAML.load_file(Rails.root.join('config', 'cfme_bz.yml'))[Rails.env] rescue {"bugzilla"=>{}}
  AppConfig['bugzilla']['uri'] ||= "https://bugzilla.redhat.com/"
  AppConfig['bugzilla']['product'] ||= "CloudForms Management Engine"

  AppConfig['bugzilla']['bug_display_uri'] = AppConfig['bugzilla']['uri'] + "/show_bug.cgi?id="
end

