module ReportTablesHelper

  def get_latest_bz_query(name)
    BzQuery.find_by_name(name).bz_query_outputs.order(:id).last.id
  end

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

  def get_query_output(report_table)
    if report_table.query_id == 0
       report_table.query_id = get_latest_bz_query(report_table.query_name)
    end
    BzQueryOutput.find_by_id(report_table.query_id).output
  end
    
  def get_query_element(element_name, query_id)
    BzQueryOutput.find_by_id(query_id).send(element_name.downcase)
  end

  def set_table_bz_count!(table, bz_query_out, hori_up, vert_up)
    table.keys.each do |kh|
      table[kh].keys.each do |kv|
        cnt = bz_query_out.scan(/#{hori_up}: #{kh}.*#{vert_up}: #{kv}/).count
        # Check if elements are flipped around in the output.
        if cnt == 0
          cnt = bz_query_out.scan(/#{vert_up}: #{kv}.*#{hori_up}: #{kh}/).count
        end
        table[kh][kv] = cnt
      end
    end
    table
  end

end
    
