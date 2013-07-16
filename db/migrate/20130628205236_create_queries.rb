class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :name
      t.text :description
      t.string :product
      t.string :flag
      t.string :bug_status
      t.string :output_format

      t.timestamps
    end
  end
end
