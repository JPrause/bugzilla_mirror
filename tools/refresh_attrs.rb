#
# Script to update the current database with specific attributes
# from the Bugzilla server last synced with. Not to be used
# for high runners like comments, assigned_to and flags.
#
# Run in Rails Console.
#

require 'active_bugzilla'
include ApplicationHelper

uri = BugzillaConfig.get_config("uri")

puts "Enter a comma-seperated list of attributes to refresh:"
attrs = gets.strip.gsub(/[\s:]+/, "").split(",").collect(&:to_sym)

if attrs.blank?
  puts "Must specified one or more attributes to refresh"
elsif uri.blank?
  puts "Database must first be bulk-loaded from a Bugzilla Server"
else
  issues = Issue.select(:bug_id).collect(&:bug_id)
  puts "Found #{issues.count} issues ..."

  puts "Refreshing #{attrs} from #{uri} ..."

  service = ActiveBugzilla::Service.new(uri, bz_options["username"], bz_options["password"])
  ActiveBugzilla::Base.service = service

  puts "Fetching #{attrs} from #{uri} ..."
  bugs = ActiveBugzilla::Bug.find(:id => issues, :include_fields => [:id] | attrs)

  puts "Done Fetching #{attrs} from #{uri}"

  puts "Updating #{attrs} in Database ..."
  bugs.each do |bug|
    issue = Issue.find_by_bug_id(bug.id)
    attr_hash = attrs.each_with_object({}) { |key, hash| hash[key] = bug.send(key) }
    issue.update_attributes!(attr_hash)
  end
end
