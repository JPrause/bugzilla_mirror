class StatisticsReportsController < ApplicationController
  def index

    # Find all of the available versions.
    versions = []
    Issue.group(:version).each do |x|
      versions << x.version
    end

    # Make a table of hashes with one entry for each versions.
    @table = {}
    @table = Hash[*versions.sort.each.collect {|v| [v, {}]}.flatten]

    # Calculate the count of bugs per version and per status.
    versions.each do |x|
      @table[x] =
        Issue.
          where(:version => x).
          group(:status).
          select("status, COUNT(status) as count").
          each_with_object({}) { |i, h| h[i.status] = i.count }
    end

  end
end
