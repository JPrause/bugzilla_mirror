class AddDepIdToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :dep_id, :text
  end
end
