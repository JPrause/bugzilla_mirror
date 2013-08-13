module ReportTablesHelper

  def get_latest_bz_query(name)
    past_query_run_id = 0
    begin
      BzQuery.find_by_name(name).bz_query_outputs.each do |run|
        past_query_run_id = run.id
      end
    rescue => err
      raise "Failure for Query: #{name} \n #{err.class.name}: #{err}"
    end

    past_query_run_id
  end

  def get_bz_query_run_times(name)
    past_query_runs = []
    begin
      BzQuery.find_by_name(name).bz_query_outputs.each do |run|
        past_query_runs << [run.updated_at, run.id]    
      end
      past_query_runs << ["LATEST", "LATEST"]    
    rescue => err
      past_query_runs = [['NONE', 0]]
      logger.error "Failure for Query: #{name} \n #{err.class.name}: #{err}"
    end

    past_query_runs
  end

  def get_query_time(query_id)
    begin
      BzQueryOutput.find_by_id(query_id).updated_at
    rescue
      logger.info "Output for Query: \'#{query_id}\' not found, assume LATEST"
      "LATEST"
    end
  end
    
  def get_query_output(report_table)
      puts "JJV -910- Invoked: get_query_output(#{report_table.query_id} #{report_table.query_name})"
      if report_table.query_id == 0
         report_table.query_id = get_latest_bz_query(report_table.query_name)
      end
      BzQueryOutput.find_by_id(report_table.query_id).output
  end
    
  def get_query_element(element_name, query_id)
    puts "JJV -920- Invoked: get_query_element(#{element_name} #{query_name})"
    # JJV - There must be an easier way to map a string to a method name?
    begin
      case element_name
        when "PRODUCT"
          BzQueryOutput.find_by_id(query_id).product
        when "FLAG"
          BzQueryOutput.find_by_id(query_id).flag
        when "BUG_STATUS"
          BzQueryOutput.find_by_id(query_id).bug_status
        when "BZ_ID"
          BzQueryOutput.find_by_id(query_id).bz_id
        when "VERSION"
          BzQueryOutput.find_by_id(query_id).version
        else
          []
      end
    rescue
      raise "Element \"#{element_name.downcase}\' for Query: \'#{query_id}\' not found"
    end
  end
    
end
