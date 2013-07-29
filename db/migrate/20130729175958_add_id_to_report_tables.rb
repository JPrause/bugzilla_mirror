class AddIdToReportTables < ActiveRecord::Migration
  def change
    add_column :report_tables, :query_id, :integer
  end
end
