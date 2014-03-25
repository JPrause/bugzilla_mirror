require 'yaml'

#
# Mixin for Application Configuration and Logging
#
module ApplicationMixin
  #
  # Config File Methods
  #
  def app_options
    @options ||= YAML.load_file(Rails.root.join('config', 'cfme_bz.yml'))[Rails.env]
  end

  def bz_options
    app_options['bugzilla']
  end

  def bz_uri
    bz_options['uri']
  end

  def bz_product
    bz_options['product']
  end

  def bz_update_config
    BugzillaConfig.update_synctime
    BugzillaConfig.set_config(:uri, bz_uri)
    BugzillaConfig.set_config(:product, bz_product)
  end

  #
  # Logging Methods
  #
  def log_info(msg)
    Rails.logger.info("#{self.class.name}: #{msg}")
  end

  def log_debug(msg)
    Rails.logger.debug("#{self.class.name}: #{msg}")
  end

  def log_error(msg)
    Rails.logger.error("#{self.class.name}: #{msg}")
  end
end
