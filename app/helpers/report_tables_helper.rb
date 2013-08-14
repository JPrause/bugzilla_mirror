module ReportTablesHelper

  def get_latest_bz_query(name)
    past_query_run_id = 0
    BzQuery.find_by_name(name).bz_query_outputs.each do |run|
      past_query_run_id = run.id
    end

    past_query_run_id
  end

  def get_bz_query_run_times(name)
    past_query_runs = []
    query = BzQuery.find_by_name(name)
    if query.respond_to?('bz_query_outputs')
      BzQuery.find_by_name(name).bz_query_outputs.each do |run|
        past_query_runs << [run.updated_at, run.id]    
      end
    end
    past_query_runs << ["LATEST", "LATEST"]    
  end

  def get_bz_query_run_time(query_id)
    output = BzQueryOutput.find_by_id(query_id)
    output.respond_to?('updated_at') ? output.updated_at : "LATEST" 
  end

  def get_query_output(report_table)
      if report_table.query_id == 0
         report_table.query_id = get_latest_bz_query(report_table.query_name)
      end
      BzQueryOutput.find_by_id(report_table.query_id).output
  end
    
  def get_query_element(element_name, query_id)
    output = BzQueryOutput.find_by_id(query_id)
    output.respond_to?(element_name.downcase) ? output.send(element_name.downcase) : []
  end

end
    
