def r_str
  ActiveSupport::SecureRandom.hex(3)
end
  
Factory.define :crime do |c|
  c.sequence(:case_id) {|i| 10000000 + i }
  c.district 690
  c.reported_at  'Sun, 26 Sep 2010 01:30:00 PDT -07:00'
  c.precinct  'PORTLAND PREC NO'
  c.address  'NE HOLLADAY ST and NE 1ST AVE, PORTLAND, OR 97232'
  c.loc 'lat' => -122.6647148823268, 'lon' => 45.530095588454486
  c.code  'si'
end

Factory.define :neighborhood do |n|
  n.sequence(:name) {|i| "Portland #{i}" }
  n.permalink {|n| "#{n.name.parameterize}" }
  n.portland true
  n.geo 'type' => 'Polygon', 'coordinates' => []
  n.properties {|n| {"OBJECTID"=>86.0, "PERIMETER"=>44728.800781, "ASSN_"=>0.0, "ASSN_ID"=>0.0, "NAME"=> n.name, "COMMPLAN"=>"", "SHARED"=>"", "COALIT"=>"SWNI", "CHECK_"=>"y", "HORZ_VERT"=>"VERT"}}
  n.after_build {|n| 5.times { n.crimes << Factory.build(:crime) } }  
end

Factory.define :offense do |o|
  o.desc "Any willful burning or attempt to burn a building"
  o.sequence(:name) {|i|  "Arson #{i}" }
  o.sequence(:order) {|i| i }
  o.type 'name' => 'Non-Violent', 'order' => 1
  o.after_build {|o| 5.times { o.crimes << Factory.build(:crime) } }
end