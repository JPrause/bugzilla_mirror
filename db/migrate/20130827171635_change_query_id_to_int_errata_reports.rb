class ChangeQueryIdToIntErrataReports < ActiveRecord::Migration
  def up
    change_column :errata_reports, :query_id, :integer
  end

  def down
    change_column :errata_reports, :query_id, :string
  end
end
