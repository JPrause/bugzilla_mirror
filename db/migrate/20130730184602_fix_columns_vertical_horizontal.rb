class FixColumnsVerticalHorizontal < ActiveRecord::Migration
  def up
    rename_column :report_tables, :Horizontal, :horizontal
    rename_column :report_tables, :Vertical, :vertical
  end

  def down
    rename_column :report_tables, :horizontal, :Horizontal
    rename_column :report_tables, :vertical, :Vertical
  end
end
