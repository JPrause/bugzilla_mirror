class ChangeVersionStringToText < ActiveRecord::Migration
  def up
    change_column :bz_query_outputs, :product, :text
    change_column :bz_query_outputs, :flag, :text
    change_column :bz_query_outputs, :bug_status, :text
    change_column :bz_query_outputs, :bz_id, :text
    change_column :bz_query_outputs, :version, :text
  end

  def down
    change_column :bz_query_outputs, :product, :string
    change_column :bz_query_outputs, :flag, :string
    change_column :bz_query_outputs, :bug_status, :string
    change_column :bz_query_outputs, :bz_id, :string
    change_column :bz_query_outputs, :version, :string
  end
end
