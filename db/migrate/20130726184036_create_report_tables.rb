class CreateReportTables < ActiveRecord::Migration
  def change
    create_table :report_tables do |t|
      t.string :name
      t.text :description
      t.text :query_name
      t.string :Vertical
      t.string :Horizontal

      t.timestamps
    end
  end
end
