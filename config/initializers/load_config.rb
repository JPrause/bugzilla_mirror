require 'ostruct'
require 'yaml'

AppConfig = YAML.load_file(Rails.root.join('config', 'cfme_bz.yml'))[Rails.env] rescue {"bugzilla"=>{}}

AppConfig['bugzilla']['uri'] ||= "https://bugzilla.redhat.com/"
AppConfig['bugzilla']['product'] ||= "CloudForms Management Engine"

