include ApplicationHelper

class Query < ActiveRecord::Base
  attr_accessible :bug_status, :description, :flag, :name, :output_format, :product

  def run(query)
    BugzillaAccess.login! unless BugzillaAccess.logged_in?
    query_cmd = "/usr/bin/bugzilla query " \
                "--product=\"#{query.product}\" " \
                "--flag=#{query.flag} " \
                "--bug_status=#{query.bug_status} " \
                "--outputformat=\'#{query.output_format}\'"
    %x[ #{query_cmd} ]
  end
end
