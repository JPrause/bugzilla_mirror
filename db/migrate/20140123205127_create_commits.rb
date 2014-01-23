class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :branch
      t.string :sha_id
      t.timestamps
    end

    create_table :commits_issues do |t|
      t.belongs_to :issue
      t.belongs_to :commit
    end
  end
end
