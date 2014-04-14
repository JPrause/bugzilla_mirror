class FixIssuesColumnTypes < ActiveRecord::Migration
  def up
    remove_column :issues, :bug_id
    add_column    :issues, :bug_id,        :integer
    change_column :issues, :cc,            :text
    change_column :issues, :release_notes, :text
    change_column :issues, :resolution,    :text
  end
end
