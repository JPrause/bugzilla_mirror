# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Issue.delete_all
Issue.create(
  bz_id: '1653',
  status: 'jjv_status',
  assigned_to: 'calvin@hobbes.com',
  summary: 'jjv summary Dragonfly',
  version: 'jjv_version',
  version_ack: '-',
  devel_ack: '-',
  doc_ack: '-',
  pm_ack: '-',
  qa_ack: '-'
)
Issue.create(
  bz_id: '1906',
  status: 'jjv_status',
  assigned_to: 'calvin@hobbes.com',
  summary: 'jjv summary Swallow',
  version: 'jjv_version',
  version_ack: '-',
  devel_ack: '+',
  doc_ack: '-',
  pm_ack: '+',
  qa_ack: '-'
)

