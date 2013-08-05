class ReportTable < ActiveRecord::Base
  attr_accessible :horizontal, :vertical, :description, :name,
    :query_name, :query_id

  def run(report_table)
    # For the initial pass simply return the unmanipulated
    # query output.

    bz_query_id = BzQuery.find_by_name(report_table.query_name)
    raise "Query: \'#{report_table.query_name}\' not found" unless bz_query_id
    bz_query_out = bz_query_id.run(bz_query_id)

    # TBD: JJV - Move the below bz_query_out regexp/parse/scan code to a
    # shared helper class.

    # Add code to calculate the report stats and produce the
    # correct report data from the query.

    hori = bz_query_out.scan(/(?<=#{report_table.horizontal}:\s)\S*/)
    vert = bz_query_out.scan(/(?<=#{report_table.vertical}:\s)\S*/)

    # Because regexp lookahead and lookbehind must be a fixed length
    # removing the sometimes occuring trailing ->'<- character must
    # be done in a separate step.
    hori.each do |x|
      x.sub!(/'$/, '')
    end

    vert.each do |x|
      x.sub!(/'$/, '')
    end

    table = {}
    table = Hash[*hori.uniq.sort.each.collect { |v| [v, {}] }.flatten ]

    hori.uniq.sort.each do |h|
      table[h] = Hash[*vert.uniq.sort.each.collect { |v| [v, 0] }.flatten ]
    end

    table.keys.each do |kh|
      table[kh].keys.each do |kv|
        # TDB: JJV - Fix this to detect when vertical comes after | before horizontal.
        cnt = bz_query_out.scan(/#{report_table.horizontal}: #{kh}.*#{report_table.vertical}: #{kv}/).count
	table[kh][kv] = cnt
      end
    end

    table

  end

end
