def r_str
  ActiveSupport::SecureRandom.hex(3)
end
  
Factory.define :crime do |c|
  c.case_id 12022753
  c.district 690
  c.reported_at  'Sun, 26 Sep 2010 01:30:00 PDT -07:00'
  c.precinct  'PORTLAND PREC NO'
  c.address  'NE HOLLADAY ST and NE 1ST AVE, PORTLAND, OR 97232'
  c.loc 'lat' => -122.6647148823268, 'lon' => 45.530095588454486
  c.code  'si'
  
  c.after_build do |crime|
    crime.neighborhood = Factory.build(:neighborhood)
  end
end

Factory.define :neighborhood do |n|
  n.sequence(:name) {|i| "Portland #{i}" }
  n.permalink {|n| "#{n.name.parameterize}" }
  n.portland true
  n.geo 'type' => 'Polygon', 'coordinates' => []
  n.properties {|n| {"OBJECTID"=>86.0, "PERIMETER"=>44728.800781, "ASSN_"=>0.0, "ASSN_ID"=>0.0, "NAME"=> n.name, "COMMPLAN"=>"", "SHARED"=>"", "COALIT"=>"SWNI", "CHECK_"=>"y", "HORZ_VERT"=>"VERT"}}
end

Factory.define :offense do |o|
  o.desc "Any willful burning or attempt to burn a building"
  o.name 'Arson'
  o.permalink {|o| o.name.parameterize }
  o.order 0
  o.type 'name' => 'Non-Violent', 'order' => 1
  o.code {|o| o.permalink[0..1] }
end