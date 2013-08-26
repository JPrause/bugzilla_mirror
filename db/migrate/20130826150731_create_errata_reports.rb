class CreateErrataReports < ActiveRecord::Migration
  def change
    create_table :errata_reports do |t|
      t.string :name
      t.text :description
      t.string :query_id
      t.string :query_name
      t.string :query_occurance
      t.string :version
      t.string :email_addr_pm_ack
      t.string :email_addr_devel_ack
      t.string :email_addr_qa_ack
      t.boolean :send_email_pm_ack
      t.boolean :send_email_devel_ack
      t.boolean :send_email_qa_ack

      t.timestamps
    end
  end
end
