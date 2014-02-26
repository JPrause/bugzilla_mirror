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

ActiveRecord::Schema.define(:version => 20_140_123_205_127) do

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
    t.string   "bz_id"
    t.string   "status"
    t.string   "assigned_to"
    t.string   "summary"
    t.string   "flag_version"
    t.string   "version_ack"
    t.string   "pm_ack"
    t.string   "devel_ack"
    t.string   "qa_ack"
    t.string   "doc_ack"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.text     "depends_on_ids"
  end

end
