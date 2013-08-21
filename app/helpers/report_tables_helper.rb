module ReportTablesHelper

  def get_bz_query_run_times(name)
    past_query_runs = []
    BzQuery.find_by_name(name).bz_query_outputs.order(:updated_at).each do |run|
      past_query_runs << [run.updated_at, run.id]    
    end unless BzQuery.find_by_name(name) == nil
    past_query_runs << ["LATEST", "LATEST"]    
  end

  def get_bz_query_run_time(query_id)
    query_id == nil || query_id == 0 ? "LATEST" :
      BzQueryOutput.find_by_id(query_id).updated_at
  end

end
    
