class CreateBzQueryEntries < ActiveRecord::Migration
  def change
    create_table :bz_query_entries do |t|
      t.references :bz_query_output
      t.string :bz_id
      t.string :verion
      t.string :pm_ack
      t.string :devel_ack
      t.string :qa_ack
      t.string :doc_ack
      t.string :status

      t.timestamps
    end
    add_index :bz_query_entries, :bz_query_output_id
  end
end
