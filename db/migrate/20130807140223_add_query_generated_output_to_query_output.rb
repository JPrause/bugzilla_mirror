class AddQueryGeneratedOutputToQueryOutput < ActiveRecord::Migration
  def change
    add_column :bz_query_outputs, :product, :string
    add_column :bz_query_outputs, :flag, :string
    add_column :bz_query_outputs, :bug_status, :string
  end
end
