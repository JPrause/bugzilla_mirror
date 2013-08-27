class RenameOccuranceToOccurrenceErrataReports < ActiveRecord::Migration
  def up
    rename_column :errata_reports, :query_occurance, :query_occurrence
  end

  def down
    rename_column :errata_reports, :query_occurrence, :query_occurance
  end
end
