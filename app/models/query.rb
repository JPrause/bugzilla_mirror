class Query < ActiveRecord::Base
  attr_accessible :bug_status, :description, :flag, :name, :outputformat, :product

  def run( query )
    query_cmd = "/usr/bin/bugzilla query " \
                "--product=\"#{query.product}\" " \
                "--flag=#{query.flag} " \
                "--bug_status=#{query.bug_status} " \
                "--outputformat=\'#{query.outputformat}\'"

    # %x[/usr/bin/bugzilla query --product=\"CloudForms Management Engine\" --flag= --bug_status=POST --outputformat='%{id},%{flags}']

    %x[ #{query_cmd} ]
  end
end
