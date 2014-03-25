class StatisticsReportsController < ApplicationController
  def index
    # Find all of the available flag versions, and related states & counts
    flag_versions_hash = Hash.new { |h, flag_version| h[flag_version] = Hash.new(0) }

    Issue.select([:status, :flags]).each do |issue|
      flag_version = get_flag_version(issue.flag_hash)
      flag_versions_hash[flag_version][issue.status] += 1
    end

    @table = Hash[flag_versions_hash.sort_by { |k, v| k.downcase }]
  end
end
