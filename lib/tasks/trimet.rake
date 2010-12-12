namespace :trimet do
  namespace :import do
    desc 'Import Trimet Bus, Max, and Streetcar Stops'
    task :stops => :environment do
      file = Pathname.new(Rails.root) + 'db' + 'data' + 'trimet-stops.json'
      stops = JSON.parse(File.read(file))['features']
      
      stops.each do |s|
        props = s['properties']
        geo   = s['geometry']['coordinates']
        stop = TrimetStop.new(:stop_id => props['stop_id'])

        stop.name = props['stop_name']
        stop.jurisdiction = props['jurisdic']
        stop.zipcode = props['zipcode']
        stop.type = props['type'].downcase
        stop.loc = {'lat' => geo[0], 'lon' => geo[1]}
        stop.save
      end
      TrimetStop.ensure_index([[:loc, "2d"]])
      TrimetStop.ensure_index(:type)
    end
    
    desc 'Import Trimet Bus, Max, and Streetcar Stops'
    task :routes => :environment do
      raise "Already Imported Routes" if TrimetRoute.count < 0
      
      file = Pathname.new(Rails.root) + 'db' + 'data' + 'lightrail-routes.json'
      routes = JSON.parse(File.read(file))['features']
      
      routes.each do |r|
        props = r['properties']
        route = TrimetRoute.new
        route.type = props['TYPE'].downcase
        route.status = props['STATUS'].downcase
        route.tunnel = props['TUNNEL']
        route.line = props['LINE']
        route.length = props['LENGTH']
        route.geo = r['geometry']
        route.save
      end
      
      TrimetRoute.ensure_index([[:type, 1], [:status, 1]])
    end
  end
end