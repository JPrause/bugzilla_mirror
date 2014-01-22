class StatisticsReportsController < ApplicationController
  def index

    # Find all of the available flag versions.
    flag_versions = []
    Issue.group(:flag_version).each do |x|
      flag_versions << x.flag_version
    end

    # Make a table of hashes with one entry for each flag versions.
    @table = {}
    @table = Hash[*flag_versions.sort.each.collect {|v| [v, {}]}.flatten]

    # Calculate the count of bugs per flag version and per status.
    flag_versions.each do |x|
      @table[x] =
        Issue.
          where(:flag_version => x).
          group(:status).
          select("status, COUNT(status) as count").
          each_with_object({}) { |i, h| h[i.status] = i.count }
    end

  end
end
