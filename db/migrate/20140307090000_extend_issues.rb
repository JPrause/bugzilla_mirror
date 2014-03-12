class ExtendIssues < ActiveRecord::Migration
  def change
    add_column :issues, :bug_id, :string
    add_column :issues, :bug_type, :string
    add_column :issues, :actual_time, :string
    add_column :issues, :alias, :string
    add_column :issues, :bug_group, :string
    add_column :issues, :build_id, :string
    add_column :issues, :category, :string
    add_column :issues, :cc, :string
    add_column :issues, :cc_list_accessible, :string
    add_column :issues, :classification, :string
    add_column :issues, :commenter, :string
    add_column :issues, :component, :string
    add_column :issues, :created_by, :string
    add_column :issues, :cust_facing, :string
    add_column :issues, :days_elapsed, :string
    add_column :issues, :deadline, :string
    add_column :issues, :doc_type, :string
    add_column :issues, :docs_contact, :string
    add_column :issues, :documentation_action, :string
    add_column :issues, :environment, :string
    add_column :issues, :estimated_time, :string
    add_column :issues, :everconfirmed, :string
    add_column :issues, :fixed_in, :string
    add_column :issues, :flags, :string
    add_column :issues, :internal_whiteboard, :string
    add_column :issues, :keywords, :string
    add_column :issues, :layered_products, :string
    add_column :issues, :mount_type, :string
    add_column :issues, :op_sys, :string
    add_column :issues, :owner_idle_time, :string
    add_column :issues, :partner, :string
    add_column :issues, :percentage_complete, :string
    add_column :issues, :pgm_internal, :string
    add_column :issues, :platform, :string
    add_column :issues, :pm_score, :string
    add_column :issues, :priority, :string
    add_column :issues, :product, :string
    add_column :issues, :qa_contact, :string
    add_column :issues, :qa_whiteboard, :string
    add_column :issues, :qe_conditional_nak, :string
    add_column :issues, :regression_status, :string
    add_column :issues, :release_notes, :string
    add_column :issues, :remaining_time, :string
    add_column :issues, :reporter_accessible, :string
    add_column :issues, :reporter_realname, :string
    add_column :issues, :resolution, :string
    add_column :issues, :rh_sub_components, :string
    add_column :issues, :see_also, :string
    add_column :issues, :severity, :string
    add_column :issues, :story_points, :string
    add_column :issues, :tag, :string
    add_column :issues, :target_milestone, :string
    add_column :issues, :target_release, :string
    add_column :issues, :url, :string
    add_column :issues, :vcs_commits, :string
    add_column :issues, :verified, :string
    add_column :issues, :verified_branch, :string
    add_column :issues, :version, :string
    add_column :issues, :view, :string
    add_column :issues, :votes, :string
    add_column :issues, :whiteboard, :string
    add_column :issues, :work_time, :string

    add_index  :issues, :bug_id, :unique => true
    add_index  :issues, :classification
    add_index  :issues, :priority
    add_index  :issues, :status
    add_index  :issues, :severity
    add_index  :issues, :assigned_to
  end
end
