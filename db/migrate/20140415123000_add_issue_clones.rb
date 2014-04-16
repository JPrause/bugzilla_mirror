class AddIssueClones < ActiveRecord::Migration
  def change
    # Cloned Issues
    create_table :issues_clones, :id => false do |t|
      t.integer :issue_id
      t.integer :clone_id
    end

    add_index :issues_clones, :issue_id
    add_index :issues_clones, :clone_id
  end
end
