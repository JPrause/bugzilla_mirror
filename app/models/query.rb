include ApplicationHelper

class Query < ActiveRecord::Base
  attr_accessible :bug_status, :description, :flag, :name, :output_format, :product

  def run(query)
    puts "JJV -010 in run BZ_CMD ->#{BZ_CMD}"
    puts "JJV -010 in run BZ_COOKIES_FILE ->#{BZ_COOKIES_FILE}"
    puts "JJV -010 in run BZ_CREDS_FILE ->#{BZ_CREDS_FILE}"
    bz_login!
    puts "JJV -010 in run"
    query_cmd = "#{BZ_CMD} query " \
                "--product=\"#{query.product}\" " \
                "--flag=#{query.flag} " \
                "--bug_status=#{query.bug_status} " \
                "--outputformat=\'#{query.output_format}\'"
    %x[ #{query_cmd} ]
  end
end
