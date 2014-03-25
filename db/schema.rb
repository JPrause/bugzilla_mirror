# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140412150000) do

  create_table "bugzilla_configs", :force => true do |t|
    t.string "name",  :null => false
    t.string "value"
  end

  add_index "bugzilla_configs", ["name"], :name => "index_bugzilla_configs_on_name", :unique => true

  create_table "comments", :force => true do |t|
    t.integer  "count"
    t.text     "text"
    t.string   "created_by"
    t.datetime "created_on"
    t.boolean  "private"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "issue_id"
  end

  add_index "comments", ["issue_id"], :name => "index_comments_on_issue_id"

  create_table "commits", :force => true do |t|
    t.string   "branch"
    t.string   "sha_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "commits_issues", :force => true do |t|
    t.integer "issue_id"
    t.integer "commit_id"
  end

  create_table "issues", :force => true do |t|
    t.string   "status"
    t.string   "assigned_to"
    t.string   "summary"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "bug_id"
    t.string   "bug_type"
    t.string   "actual_time"
    t.string   "alias"
    t.string   "bug_group"
    t.string   "build_id"
    t.string   "category"
    t.string   "cc"
    t.string   "cc_list_accessible"
    t.string   "classification"
    t.string   "commenter"
    t.string   "component"
    t.string   "created_by"
    t.string   "cust_facing"
    t.string   "days_elapsed"
    t.string   "deadline"
    t.string   "doc_type"
    t.string   "docs_contact"
    t.string   "documentation_action"
    t.string   "environment"
    t.string   "estimated_time"
    t.string   "everconfirmed"
    t.string   "fixed_in"
    t.string   "flags"
    t.string   "internal_whiteboard"
    t.string   "keywords"
    t.string   "layered_products"
    t.string   "mount_type"
    t.string   "op_sys"
    t.string   "owner_idle_time"
    t.string   "partner"
    t.string   "percentage_complete"
    t.string   "pgm_internal"
    t.string   "platform"
    t.string   "pm_score"
    t.string   "priority"
    t.string   "product"
    t.string   "qa_contact"
    t.string   "qa_whiteboard"
    t.string   "qe_conditional_nak"
    t.string   "regression_status"
    t.string   "release_notes"
    t.string   "remaining_time"
    t.string   "reporter_accessible"
    t.string   "reporter_realname"
    t.string   "resolution"
    t.string   "rh_sub_components"
    t.string   "see_also"
    t.string   "severity"
    t.string   "story_points"
    t.string   "tag"
    t.string   "target_milestone"
    t.string   "target_release"
    t.string   "url"
    t.string   "vcs_commits"
    t.string   "verified"
    t.string   "verified_branch"
    t.string   "version"
    t.string   "view"
    t.string   "votes"
    t.string   "whiteboard"
    t.string   "work_time"
  end

  add_index "issues", ["assigned_to"], :name => "index_issues_on_assigned_to"
  add_index "issues", ["bug_id"], :name => "index_issues_on_bug_id", :unique => true
  add_index "issues", ["classification"], :name => "index_issues_on_classification"
  add_index "issues", ["priority"], :name => "index_issues_on_priority"
  add_index "issues", ["severity"], :name => "index_issues_on_severity"
  add_index "issues", ["status"], :name => "index_issues_on_status"

  create_table "issues_blocks", :id => false, :force => true do |t|
    t.integer "issue_id"
    t.integer "blocked_issue_id"
  end

  add_index "issues_blocks", ["blocked_issue_id"], :name => "index_issues_blocks_on_blocked_issue_id"
  add_index "issues_blocks", ["issue_id"], :name => "index_issues_blocks_on_issue_id"

  create_table "issues_dependencies", :id => false, :force => true do |t|
    t.integer "issue_id"
    t.integer "dependent_id"
  end

  add_index "issues_dependencies", ["dependent_id"], :name => "index_issues_dependencies_on_dependent_id"
  add_index "issues_dependencies", ["issue_id"], :name => "index_issues_dependencies_on_issue_id"

  create_table "issues_duplicates", :id => false, :force => true do |t|
    t.integer "issue_id"
    t.integer "duplicate_id"
  end

  add_index "issues_duplicates", ["duplicate_id"], :name => "index_issues_duplicates_on_duplicate_id"
  add_index "issues_duplicates", ["issue_id"], :name => "index_issues_duplicates_on_issue_id"

end
