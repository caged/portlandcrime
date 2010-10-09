# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

offenses = JSON.parse(File.read('db/data/offenses.json'))
offenses.each do |off|
  permalink = off['name'].parameterize
  puts "==> #{permalink}"
  offense = Offense.first_or_new(:permalink => permalink)
  offense.name = off['name']
  offense.desc = off['desc']
  offense.order = off['order']
  offense.code  = permalink[0..1]
  offense.type = {:name => off['type'], :order => off['group_order']}
  offense.save
end

Offense.ensure_index(:permalink)
Offense.ensure_index(:code)

Crime.ensure_index([[:loc, "2d"]])
Crime.ensure_index(:case_id)