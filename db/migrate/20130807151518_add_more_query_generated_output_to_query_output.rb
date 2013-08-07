class AddMoreQueryGeneratedOutputToQueryOutput < ActiveRecord::Migration
  def change
    add_column :bz_query_outputs, :bz_id, :string
    add_column :bz_query_outputs, :version, :string
  end
end
