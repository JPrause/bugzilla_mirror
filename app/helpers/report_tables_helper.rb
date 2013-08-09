module ReportTablesHelper

  def get_bz_query_run_times(name)
    past_query_runs = []
    begin
      BzQuery.find_by_name(name).bz_query_outputs.each do |run|
        past_query_runs << [run.updated_at, run.id]    
      end
    rescue => err
      past_query_runs = [['NONE', 0]]
      logger.error "Failure for Query: #{name} \n #{err.class.name}: #{err}"
    end

    past_query_runs
  end

end
