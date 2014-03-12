# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name                  =>              'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name                  =>              'Emanuel', city: cities.first)
Issue.delete_all
Issue.create(
  :bug_id         => '1653',
  :status         => 'POST',
  :assigned_to    => 'calvin@hobbes.com',
  :summary        => 'summary Dragonfly',
)
Issue.create(
  :bug_id         => '1906',
  :status         => 'MODIFIED',
  :assigned_to    => 'calvin@hobbes.com',
  :summary        => 'summary Swallow',
)
Issue.create(
  :bug_id         => '1822',
  :status         => 'POST',
  :assigned_to    => 'calvin@hobbes.com',
  :summary        => 'summary Swallow',
)
