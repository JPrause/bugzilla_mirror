class RenameIssuesVersionToFlagVersion < ActiveRecord::Migration
  def up
    rename_column :issues, :version, :flag_version
  end

  def down
    rename_column :issues, :flag_version, :version
  end
end
