require 'ostruct'
require 'yaml'

APP_CONFIG = begin
  YAML.load_file(Rails.root.join('config', 'cfme_bz.yml'))[Rails.env]
rescue Errno::ENOENT
  {"bugzilla" => {}}
end

APP_CONFIG['bugzilla']['uri']     ||= "https://bugzilla.redhat.com"
APP_CONFIG['bugzilla']['product'] ||= "CloudForms Management Engine"

BZ_CONFIG = APP_CONFIG['bugzilla']
