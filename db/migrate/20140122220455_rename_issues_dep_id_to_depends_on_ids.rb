class RenameIssuesDepIdToDependsOnIds < ActiveRecord::Migration
  def up
    rename_column :issues, :dep_id, :depends_on_ids
  end

  def down
    rename_column :issues, :depends_on_ids, :dep_id
  end
end
