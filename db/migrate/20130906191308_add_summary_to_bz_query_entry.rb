class AddSummaryToBzQueryEntry < ActiveRecord::Migration
  def change
    add_column :bz_query_entries, :summary, :string
  end
end
