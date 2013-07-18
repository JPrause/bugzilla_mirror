include ApplicationHelper

class Query < ActiveRecord::Base
  attr_accessible :bug_status, :description, :flag, :name, :output_format, :product

  def run(query)
    bz_login!
    query_cmd = "#{BZ_CMD} query " \
                "--product=\"#{query.product}\" " \
                "--flag=#{query.flag} " \
                "--bug_status=#{query.bug_status} " \
                "--outputformat=\'#{query.output_format}\'"
    %x[ #{query_cmd} ]
  end
end
