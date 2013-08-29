module QueryMixin

  def get_latest_bz_query(name)
    BzQuery.find_by_name(name).bz_query_outputs.order(:id).last.id
  end

  def get_query_output(report)
    if report.query_id == 0
       report.query_id = get_latest_bz_query(report.query_name)
    end
    BzQueryOutput.find_by_id(report.query_id).output
  end
    
  def get_query_entries(report)
    if report.query_id == 0
       report.query_id = get_latest_bz_query(report.query_name)
    end
    BzQueryOutput.find_by_id(report.query_id).bz_query_entries
  end
    
  def get_query_element(element_name, query_id)
    BzQueryOutput.find_by_id(query_id).send(element_name.downcase)
  end

end
    
