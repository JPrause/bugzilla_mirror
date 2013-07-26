# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# encoding: utf-8
Query.delete_all
Query.create(
  name: 'Query1',
  description: 'List bugs in POST without a version flag.',
  product: 'CloudForms Management Engine',
  flag: '',
  bug_status: 'POST',
  output_format: '%{id},%{flags}')
# . . .
Query.create(
  name: 'Query2',
  description: 'List bugs in POST for 5.2 to verify triple ack.',
  product: 'CloudForms Management Engine',
  flag: 'cfme-5.2',
  bug_status: 'POST',
  output_format: '%{id},%{flags}')
# . . .
Query.create(
  name: 'Query3',
  description: 'Verify the bugs have been properly flagged, fixed in, and set to MODIFIED.',
  product: 'CloudForms Management Engine',
  flag: 'cfme-5.2',
  bug_status: 'MODIFIED',
  output_format: '%{id},%{fixed_in},%{flags},%{status}')
# ...
Query.create(
  name: 'Query4',
  description: 'Modified & Post cfme-5.2 bugs.',
  product: 'CloudForms Management Engine',
  flag: 'cfme-5.2',
  bug_status: 'MODIFIED,POST',
  output_format: 'BUG_STATUS: %{bug_status} VERSION: %{version} FLAGS: %{flags}')
# ...
Query.create(
  name: 'Query5',
  description: 'All Modified & Post bugs.',
  product: 'CloudForms Management Engine',
  bug_status: 'MODIFIED,POST',
  output_format: 'BUG_STATUS: %{bug_status} VERSION: %{version} FLAGS: %{flags}')
