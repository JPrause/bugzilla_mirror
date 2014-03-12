class StatisticsReportsController < ApplicationController
  def index
    # Find all of the available flag versions, and related states & counts
    flag_versions_hash = {}

    Issue.select([:status, :flags]).each do |issue|
      flag_version = get_flag_version(issue.flags)
      flag_versions_hash[flag_version] ||= {}
      flag_versions_hash[flag_version][issue.status] ||= 0
      flag_versions_hash[flag_version][issue.status] += 1
    end

    flag_versions = flag_versions_hash.keys

    # Make a table of hashes with one entry for each flag versions.
    @table = {}
    @table = Hash[*flag_versions.sort.each.collect { |v| [v, {}] }.flatten]

    # Calculate the count of bugs per flag version and per status.
    flag_versions.each do |x|
      @table[x] = flag_versions_hash[x]
    end
  end
end
