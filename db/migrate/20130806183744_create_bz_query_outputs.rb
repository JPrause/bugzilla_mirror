class CreateBzQueryOutputs < ActiveRecord::Migration
  def change
    create_table :bz_query_outputs do |t|
      t.references :bz_query
      t.text :output

      t.timestamps
    end
    add_index :bz_query_outputs, :bz_query_id
  end
end
