class AddBugzillaTimestamps < ActiveRecord::Migration
  def change
    add_column :issues, :created_on, :datetime
    add_column :issues, :updated_on, :datetime

    add_index  :issues, :created_on
    add_index  :issues, :updated_on
  end
end
