class StatisticsReportsController < ApplicationController
  def index
    # Find all of the available flag versions, and related states & counts
    flag_versions_hash = Hash.new { |h, flag_version| h[flag_version] = Hash.new(0) }

    @issues_with_multiple_flag_versions = 0
    Issue.select([:status, :flags]).each do |issue|
      flag_versions = get_flag_versions(issue.flag_hash)
      @issues_with_multiple_flag_versions += 1 if flag_versions.count > 1
      flag_versions.each { |flag_version| flag_versions_hash[flag_version][issue.status] += 1 }
    end

    @table = Hash[flag_versions_hash.sort_by { |k, v| k.downcase }]
  end
end
