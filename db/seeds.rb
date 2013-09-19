# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# encoding: utf-8
BzQuery.delete_all
q = BzQuery.create(
  name: 'ReadyErrata',
  description: 'List bugs in POST to verify triple ack.',
  product: 'CloudForms Management Engine',
  flag: 'cfme-5.2',
  bug_status: 'POST',
  output_format: 'BZ_ID: %{id} BZ_ID_END SUMMARY: %{summary} SUMMARY_END BUG_STATUS: %{bug_status} BUG_STATUS_END VERSION: %{version} VERSION_END FLAGS: %{flags} FLAGS_END KEYWORDS: %{keywords} KEYWORDS_END ')
q.run
# ...
ReportTable.delete_all
ReportTable.create(
  name: 'Report1',
  description: 'vertical=Version horizontal=Status',
  query_name: 'Query7',
  query_id: BzQuery.find_by_name('Query7'),
  vertical: 'version',
  horizontal: 'bug_status')
# ...
Issue.delete_all
Issue.create(
  bz_id: '1653',
  status: 'jjv_status',
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
  summary: 'jjv summary Swallow',
  version: 'jjv_version',
  version_ack: '-',
  devel_ack: '+',
  doc_ack: '-',
  pm_ack: '+',
  qa_ack: '-'
)

