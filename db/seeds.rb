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
  output_format: 'BZ_ID: %{id} BUG_STATUS: %{bug_status} VERSION: %{version} FLAGS: %{flags} KEYWORDS: %{keywords}')
q.run
# . . .
q = BzQuery.create(
  name: 'Errata_Ready_cfme-5.2',
  description: 'List bugs in POST for 5.2 to verify triple ack.',
  product: 'CloudForms Management Engine',
  flag: 'cfme-5.2',
  bug_status: 'POST',
  output_format: 'BZ_ID: %{id} BUG_STATUS: %{bug_status} VERSION: %{version} FLAGS: %{flags} KEYWORDS: %{keywords}')
q.run
# . . .
q = BzQuery.create(
  name: 'Errata_Ready_cfme-5.1.z',
  description: 'List bugs in POST for 5.1.z to verify triple ack.',
  product: 'CloudForms Management Engine',
  flag: 'cfme-5.1.z',
  bug_status: 'POST',
  output_format: 'BZ_ID: %{id} BUG_STATUS: %{bug_status} VERSION: %{version} FLAGS: %{flags} KEYWORDS: %{keywords}')
q.run
# . . .
q = BzQuery.create(
  name: 'Errata_Ready_cfme-5.0.z',
  description: 'List bugs in POST for 5.0.z to verify triple ack.',
  product: 'CloudForms Management Engine',
  flag: 'cfme-5.0.z',
  bug_status: 'POST',
  output_format: 'BZ_ID: %{id} BUG_STATUS: %{bug_status} VERSION: %{version} FLAGS: %{flags} KEYWORDS: %{keywords}')
q.run
# . . .
q = BzQuery.create(
  name: 'Errata_Ready_cfme-4.0.z',
  description: 'List bugs in POST for 4.0.z to verify triple ack.',
  product: 'CloudForms Management Engine',
  flag: 'cfme-4.0.z',
  bug_status: 'POST',
  output_format: 'BZ_ID: %{id} BUG_STATUS: %{bug_status} VERSION: %{version} FLAGS: %{flags} KEYWORDS: %{keywords}')
q.run
# . . .
q = BzQuery.create(
  name: 'Query1',
  description: 'List bugs in POST without a version flag.',
  product: 'CloudForms Management Engine',
  flag: '',
  bug_status: 'POST',
  output_format: 'BZ_ID: %{id} BUG_STATUS: %{bug_status} VERSION: %{version} FLAGS: %{flags} KEYWORDS: %{keywords}')
q.run
# . . .
q = BzQuery.create(
  name: 'Query3',
  description: 'Verify the bugs have been properly flagged, fixed in, and set to MODIFIED.',
  product: 'CloudForms Management Engine',
  flag: 'cfme-5.2',
  bug_status: 'MODIFIED',
  output_format: 'BZ_ID: %{id} BUG_STATUS: %{bug_status} VERSION: %{version} FLAGS: %{flags} KEYWORDS: %{keywords}')
q.run
# ...
q = BzQuery.create(
  name: 'Query4',
  description: 'Modified & Post cfme-5.2 bugs.',
  product: 'CloudForms Management Engine',
  flag: 'cfme-5.2',
  bug_status: 'MODIFIED,POST',
  output_format: 'BZ_ID: %{id} BUG_STATUS: %{bug_status} VERSION: %{version} FLAGS: %{flags} KEYWORDS: %{keywords}')
q.run
# ...
q = BzQuery.create(
  name: 'Query5',
  description: 'All Modified & Post bugs.',
  product: 'CloudForms Management Engine',
  bug_status: 'MODIFIED,POST',
  output_format: 'BZ_ID: %{id} BUG_STATUS: %{bug_status} VERSION: %{version} FLAGS: %{flags} KEYWORDS: %{keywords}')
q.run
# ...
q = BzQuery.create(
  name: 'Query6',
  description: 'All Modified & Post bugs.',
  product: 'CloudForms Management Engine',
  bug_status: 'MODIFIED,POST',
  output_format: 'BZ_ID: %{id} BUG_STATUS: %{bug_status} VERSION: %{version} FLAGS: %{flags} KEYWORDS: %{keywords}')
q.run
# ...
q = BzQuery.create(
  name: 'Query7',
  description: 'All Modified & Post bugs.',
  product: 'CloudForms Management Engine',
  bug_status: 'MODIFIED,POST',
  output_format: 'BZ_ID: %{id} BUG_STATUS: %{bug_status} VERSION: %{version}')
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

