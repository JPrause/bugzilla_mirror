class BugzillaConfig < ActiveRecord::Base
  SYNCTIME_PARAMETER = "last_updated_on"

  def self.get_config(name)
    find_by_name(name.to_s).try(:value) || ""
  end

  def self.set_config(name, value)
    find_or_create_by_name(name.to_s).update_attributes!(:value => value)
  end

  def self.delete_config(name)
    entry = BugzillaConfig.find_by_name(name)
    entry.destroy if entry
  end

  def self.fetch_synctime
    get_config(SYNCTIME_PARAMETER)
  end

  def self.update_synctime(timestamp)
    set_config(SYNCTIME_PARAMETER, timestamp)
  end

  def self.delete_synctime
    delete_config(SYNCTIME_PARAMETER)
  end

  def self.to_hash
    all.each_with_object({}) { |entry, hash|  hash[entry.name] = entry.value }
  end
end
