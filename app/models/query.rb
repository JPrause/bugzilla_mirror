include ApplicationHelper

class Query < ActiveRecord::Base
  attr_accessible :bug_status, :description, :flag, :name,
    :output_format, :product

  def run(query)

    bz_login!

    query_cmd = ["#{BZ_CMD}", "query"]
    query_cmd << "--product=#{query.product}" unless query.product.nil?
    query_cmd << "--flag=#{query.flag}" unless query.flag.nil?
    query_cmd << "--bug_status=#{query.bug_status}" unless
      query.bug_status.nil?
    query_cmd << "--outputformat=\'#{query.output_format}\'" unless
      query.output_format.nil?

    # Preserve query_cmd without the popen error for logging and diags.
    query_cmd_popen_err = query_cmd.dup
    query_cmd_popen_err << {:err=>[:child, :out]}
    query_cmd_out = ""

    logger.debug "Running command: #{query_cmd.join(" ")}"
    query_cmd_result = IO.popen(query_cmd_popen_err) do |io_cmd|
      query_cmd_out << io_cmd.read
    end
    raise "#{query_cmd.join(" ")} Failed.\n #{query_cmd_result}" unless
      $?.success?

    query_cmd_out
  end
end
