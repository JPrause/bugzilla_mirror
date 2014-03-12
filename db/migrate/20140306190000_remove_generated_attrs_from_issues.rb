class RemoveGeneratedAttrsFromIssues < ActiveRecord::Migration
  def remove_field(field)
    remove_column :issues, field
  end

  def change
    remove_field :bz_id
    remove_field :depends_on_ids
    remove_field :flag_version
    remove_field :version_ack
    remove_field :pm_ack
    remove_field :devel_ack
    remove_field :qa_ack
    remove_field :doc_ack
  end
end
