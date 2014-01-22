# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Issue.delete_all
Issue.create(
  bz_id:           '1653',
  depends_on_ids:  '[]',
  status:          'POST',
  assigned_to:     'calvin@hobbes.com',
  summary:         'summary Dragonfly',
  flag_version:    '5.1',
  version_ack:     '-',
  devel_ack:       '-',
  doc_ack:         '-',
  pm_ack:          '-',
  qa_ack:          '-'
)
Issue.create(
  bz_id:           '1906',
  depends_on_ids:  '1653',
  status:          'MODIFIED',
  assigned_to:     'calvin@hobbes.com',
  summary:         'summary Swallow',
  flag_version:    '',
  version_ack:     '-',
  devel_ack:       '+',
  doc_ack:         '-',
  pm_ack:          '+',
  qa_ack:          '-'
)
Issue.create(
  bz_id:           '1822',
  depends_on_ids:  '1906,1822',
  status:          'POST',
  assigned_to:     'calvin@hobbes.com',
  summary:         'summary Swallow',
  flag_version:    '',
  version_ack:     '+',
  devel_ack:       '+',
  doc_ack:         '+',
  pm_ack:          '+',
  qa_ack:          '+'
)

