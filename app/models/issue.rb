class Issue < ActiveRecord::Base
  ATTRIBUTES = [:bug_id,
                :bug_type,
                :actual_time,
                :alias,
                :assigned_to,
                :bug_group,
                :build_id,
                :category,
                :cc,
                :cc_list_accessible,
                :classification,
                :commenter,
                :component,
                :created_by,
                :cust_facing,
                :days_elapsed,
                :deadline,
                :doc_type,
                :docs_contact,
                :documentation_action,
                :environment,
                :estimated_time,
                :everconfirmed,
                :fixed_in,
                :flags,
                :internal_whiteboard,
                :keywords,
                :layered_products,
                :mount_type,
                :op_sys,
                :owner_idle_time,
                :partner,
                :percentage_complete,
                :pgm_internal,
                :platform,
                :pm_score,
                :priority,
                :product,
                :qa_contact,
                :qa_whiteboard,
                :qe_conditional_nak,
                :regression_status,
                :release_notes,
                :remaining_time,
                :reporter_accessible,
                :reporter_realname,
                :resolution,
                :rh_sub_components,
                :see_also,
                :severity,
                :status,
                :story_points,
                :summary,
                :tag,
                :target_milestone,
                :target_release,
                :url,
                :vcs_commits,
                :verified,
                :verified_branch,
                :version,
                :view,
                :votes,
                :whiteboard,
                :work_time]

  attr_accessible(*ATTRIBUTES)

  has_and_belongs_to_many :dependents,
                          :class_name              => "Issue",
                          :join_table              => "issue_dependencies",
                          :foreign_key             => "issue_id",
                          :association_foreign_key => "dependent_id"

  has_and_belongs_to_many :depended_by,
                          :class_name              => "Issue",
                          :join_table              => "issue_dependencies",
                          :foreign_key             => "dependent_id",
                          :association_foreign_key => "issue_id"

  has_and_belongs_to_many :blocked_issues,
                          :class_name              => "Issue",
                          :join_table              => "issue_blocks",
                          :foreign_key             => "issue_id",
                          :association_foreign_key => "blocked_issue_id"

  has_and_belongs_to_many :blocked_by,
                          :class_name              => "Issue",
                          :join_table              => "issue_blocks",
                          :foreign_key             => "blocked_issue_id",
                          :association_foreign_key => "issue_id"

  has_and_belongs_to_many :duplicates,
                          :class_name              => "Issue",
                          :join_table              => "issue_duplicates",
                          :foreign_key             => "issue_id",
                          :association_foreign_key => "duplicate_id"

  has_and_belongs_to_many :duplicated_by,
                          :class_name              => "Issue",
                          :join_table              => "issue_duplicates",
                          :foreign_key             => "duplicate_id",
                          :association_foreign_key => "issue_id"

  has_many :comments, :dependent => :destroy

  has_and_belongs_to_many :commits

  before_destroy do
    dependents.clear
    depended_by.clear

    blocked_issues.clear
    blocked_by.clear

    duplicates.clear
    duplicated_by.clear
  end

  ASSOCIATIONS = {
    :depends_on   => :dependents,
    :blocks       => :blocked_issues,
    :duplicate_id => :duplicates
  }

  #
  # Let's get the Description of the Issue, i.e. the initial comment.
  #
  def description
    initial_comment = comments.where(:count => 0).first
    initial_comment.blank? ? "" : initial_comment.text
  end

  #
  # Let's provide procs to return lists of bug_id's for associated Issues
  #
  def fetch_bug_ids(associations)
    associations.select(:bug_id).collect { |issue| issue.bug_id }
  end

  def dependents_bug_ids
    fetch_bug_ids(dependents)
  end

  def blocked_issues_bug_ids
    fetch_bug_ids(blocked_issues)
  end

  def duplicates_bug_ids
    fetch_bug_ids(duplicates)
  end
end
