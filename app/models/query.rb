include ApplicationHelper

class Query < ActiveRecord::Base
  attr_accessible :bug_status, :description, :flag, :name, :output_format, :product

  def run(query)
    bz_login!
    query_cmd = "#{BZ_CMD} query "
    query_cmd << "--product=\"#{query.product}\" "
    query_cmd << "--flag=#{query.flag} "
    query_cmd << "--bug_status=#{query.bug_status} "
    query_cmd << "--outputformat=\'#{query.output_format}\'"
    `#{query_cmd}`
  end
end
