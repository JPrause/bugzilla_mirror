class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :bz_id
      t.string :status
      t.string :assigned_to
      t.string :summary
      t.string :version
      t.string :version_ack
      t.string :pm_ack
      t.string :devel_ack
      t.string :qa_ack
      t.string :doc_ack

      t.timestamps
    end
  end
end
