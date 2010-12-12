namespace :trimet do
  namespace :import do
    desc 'Import Trimet Bus, Max, and Streetcar Stops'
    task :stops => :environment do
      file = Pathname.new(Rails.root) + 'db' + 'data' + 'trimet-stops.json'
      stops = JSON.parse(File.read(file))['features']
      
      stops.each do |s|
        props = s['properties']
        geo   = s['geometry']['coordinates']
        stop = TrimetStop.first_or_new(:stop_id => props['stop_id'])

        stop.name = props['stop_name']
        stop.jurisdiction = props['jurisdic']
        stop.zipcode = props['zipcode']
        stop.type = props['type'].downcase
        stop.loc = {'lat' => geo[0], 'lon' => geo[1]}
        stop.save
      end
      TrimetStop.ensure_index([[:loc, "2d"]])
    end
    
    desc 'Import Trimet Bus, Max, and Streetcar Stops'
    task :routes => :environment do
      file = Pathname.new(Rails.root) + 'db' + 'data' + 'trimet-routes.json'
      routes = JSON.parse(File.read(file))['features']
      
      routes.each do |r|
        props = r['properties']
        route = TrimetRoute.first_or_new(:route_number => props['rte'])
        route.public_route_number = props['public_rte']
        route.frequent = props['frequent'].downcase == 'false' ? false : true
        route.direction = props['dir']
        route.direction_desc = props['dir_desc']
        route.type = props['type'].downcase
        route.geo = r['geometry']
        route.save
      end
    end
  end
end