class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer    :count
      t.text       :text
      t.string     :created_by
      t.datetime   :created_on
      t.boolean    :private
      t.timestamps
      t.belongs_to :issue
    end

    add_index :comments, :issue_id
  end
end
