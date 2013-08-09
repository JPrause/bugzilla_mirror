class ReportTable < ActiveRecord::Base

  attr_accessible :horizontal, :vertical, :description, :name,
    :query_name, :query_id

  def run(report_table)

    logger.debug "JJV - report_table.query_name: #{report_table.query_name}<-"
    logger.debug "JJV - report_table.query_id: #{report_table.query_id}<-"
    logger.debug "JJV - horizontal: #{report_table.horizontal}"
    logger.debug "JJV - vertical: #{report_table.vertical}"

    bz_query_out = get_output(report_table.query_id)
    hori_up = report_table.horizontal.upcase
    vert_up = report_table.vertical.upcase
    hori_array = get_element_array(hori_up, report_table.query_id)
    vert_array = get_element_array(vert_up, report_table.query_id)

    logger.debug  "JJV - hori_array: ->#{hori_array}<-"
    logger.debug  "JJV - vert_array: ->#{vert_array}<-"

    table = {}
    table = Hash[*hori_array.uniq.sort.each.collect { |v| [v, {}] }.flatten ]

    hori_array.uniq.sort.each do |h|
      table[h] = Hash[*vert_array.uniq.sort.each.collect { |v| [v, 0] }.flatten ]
    end

    table.keys.each do |kh|
      table[kh].keys.each do |kv|
        # TDB: JJV - Fix this to detect when vertical comes after | before horizontal.
        cnt = bz_query_out.scan(/#{hori_up}: #{kh}.*#{vert_up}: #{kv}/).count
	table[kh][kv] = cnt
      end
    end

    table

  end

  private
  def get_output(query_id)
    begin
      BzQueryOutput.find_by_id(query_id).output
    rescue
      raise "Output for Query: \'#{query_id}\' not found"
    end
  end
    
  private
  def get_element_array(element_name, query_id)
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
