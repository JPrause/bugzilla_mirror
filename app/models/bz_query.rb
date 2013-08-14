include ApplicationHelper
include ReportTablesHelper


class BzQuery < ActiveRecord::Base
  attr_accessible :bug_status, :description, :flag, :name,
    :output_format, :product

  has_many :bz_query_outputs, dependent: :destroy

  def run(bz_query)

    bz_login!

    bz_query_cmd = ["#{BZ_CMD}", "query"]
    bz_query_cmd << "--product=#{bz_query.product}" unless
      bz_query.product.nil?
    bz_query_cmd << "--flag=#{bz_query.flag}" unless bz_query.flag.nil?
    bz_query_cmd << "--bug_status=#{bz_query.bug_status}" unless
      bz_query.bug_status.nil?
    bz_query_cmd << "--outputformat=\'#{bz_query.output_format}\'" unless
      bz_query.output_format.nil?

    # Preserve bz_query_cmd without the popen error for logging and diags.
    bz_query_cmd_popen_err = bz_query_cmd.dup
    bz_query_cmd_popen_err << {:err=>[:child, :out]}
    bz_query_cmd_out = ""

    logger.debug "Running command: #{bz_query_cmd.join(" ")}"
    bz_query_cmd_result = IO.popen(bz_query_cmd_popen_err) do |io_cmd|
      bz_query_cmd_out << io_cmd.read
    end
    raise "#{bz_query_cmd.join(" ")} Failed.\n #{bz_query_cmd_result}" unless
      $?.success?

    # create a new bz_query_outputs entry in the db and save this output there.
    bz_query_outputs.create(:output => bz_query_cmd_out)
    
    bz_query_cmd_out
  end
end
