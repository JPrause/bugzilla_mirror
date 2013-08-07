class ReportTable < ActiveRecord::Base
  attr_accessible :horizontal, :vertical, :description, :name,
    :query_name, :query_id

  def run(report_table)

    logger.debug "JJV - report_table.query_name: #{report_table.query_name}<-"
    logger.debug "JJV - horizontal: #{report_table.horizontal}"
    logger.debug "JJV - vertical: #{report_table.vertical}"

    bz_query_out = get_output(report_table.query_name)
    hori_up = report_table.horizontal.upcase
    vert_up = report_table.vertical.upcase
    hori_array = get_element_array(hori_up, report_table.query_name)
    vert_array = get_element_array(vert_up, report_table.query_name)

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
  def get_output(query_name)
    # For the initial pass simply report on the data from the last
    # run of the query.
    #
    # TBD: JJV Next step is to add support to allow the user to
    # select from one of the past runs of the query or to run
    # the query now.
    begin
      BzQuery.find_by_name(query_name).bz_query_outputs.last.output
    rescue
      raise "Output for Query: \'#{query_name}\' not found"
    end
  end
    
  private
  def get_element_array(element_name, query_name)
    # JJV - There must be an easier way to map a string to a method name?
    begin
      case element_name
        when "PRODUCT"
          BzQuery.find_by_name(query_name).bz_query_outputs.last.product
        when "FLAG"
          BzQuery.find_by_name(query_name).bz_query_outputs.last.flag
        when "BUG_STATUS"
          BzQuery.find_by_name(query_name).bz_query_outputs.last.bug_status
        when "BZ_ID"
          BzQuery.find_by_name(query_name).bz_query_outputs.last.bz_id
        when "VERSION"
          BzQuery.find_by_name(query_name).bz_query_outputs.last.version
        else
          []
      end
    rescue
      raise "Element \"#{element_name.downcase}\' for Query: \'#{query_name}\' not found"
    end
  end
    
end
