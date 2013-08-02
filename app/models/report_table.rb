class ReportTable < ActiveRecord::Base
  attr_accessible :horizontal, :vertical, :description, :name,
    :query_name, :query_id

  def run(report_table)
    # For the initial pass simply return the unmanipulated
    # query output.
    
    bz_query_id = BzQuery.find_by_name(report_table.query_name)
    raise "Query: \'#{report_table.query_name}\' not found" unless bz_query_id
    bz_query_id.run(bz_query_id)

    # Add code to calculate the report stats and produce the
    # correct report data from the query.
  end

end


