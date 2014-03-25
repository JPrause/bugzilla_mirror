class AddIssueAssociations < ActiveRecord::Migration
  def change
    # Dependent Issues
    create_table :issues_dependencies, :id => false do |t|
      t.integer :issue_id
      t.integer :dependent_id
    end

    add_index :issues_dependencies, :issue_id
    add_index :issues_dependencies, :dependent_id

    # Blocked Issues
    create_table :issues_blocks, :id => false do |t|
      t.integer :issue_id
      t.integer :blocked_issue_id
    end

    add_index :issues_blocks, :issue_id
    add_index :issues_blocks, :blocked_issue_id

    # Duplicate Issues
    create_table :issues_duplicates, :id => false do |t|
      t.integer :issue_id
      t.integer :duplicate_id
    end

    add_index :issues_duplicates, :issue_id
    add_index :issues_duplicates, :duplicate_id
  end
end
