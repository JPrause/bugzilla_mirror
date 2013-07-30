class CreateReportTables < ActiveRecord::Migration
  def change
    create_table :report_tables do |t|
      t.string :name
      t.text :description
      t.text :query_name
      t.string :vertical
      t.string :horizontal

      t.timestamps
    end
  end
end
