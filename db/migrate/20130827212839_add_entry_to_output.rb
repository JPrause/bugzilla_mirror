class AddEntryToOutput < ActiveRecord::Migration
  def change
    add_column :bz_query_entries, :bz_id, :string
    add_column :bz_query_entries, :pm_ack, :string
    add_column :bz_query_entries, :devel_ack, :string
    add_column :bz_query_entries, :qa_ack, :string
    add_column :bz_query_entries, :doc_ack, :string
    add_column :bz_query_entries, :status, :string
  end
end
