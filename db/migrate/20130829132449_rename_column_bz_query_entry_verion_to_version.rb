class RenameColumnBzQueryEntryVerionToVersion < ActiveRecord::Migration
  def up
    rename_column :bz_query_entries, :verion, :version
    add_column :bz_query_entries, :version_ack, :string
  end

  def down
    rename_column :bz_query_entries, :version, :verion
    remove_column :bz_query_entries, :version_ack
  end
end
