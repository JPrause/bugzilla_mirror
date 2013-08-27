class CreateBzQueryEntries < ActiveRecord::Migration
  def change
    create_table :bz_query_entries do |t|
      t.string :BzQueryOutput
      t.references :bz_entry

      t.timestamps
    end
    add_index :bz_query_entries, :bz_entry_id
  end
end
