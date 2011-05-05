namespace :transit do
  namespace :import do
    desc 'Import Transit Routes'
    task :routes => :environment do
      file = Pathname.new(Rails.root) + 'db' + 'data' + 'transit_routes.json'
      routes = JSON.parse(file.read)['features']
      routes.each do |r|
        # key :rte, Integer
        # key :prte, Integer
        # key :type
        # key :desc
        # key :dir_desc
        # key :dir, Integer
        # key :geo, Hash
        props = r['properties']
        route = TransitRoute.new
        route.rte = props['RTE'].to_i
        route.prte = props['PUBLIC_RTE'].to_i
        route.type = props['TYPE'].downcase
        route.desc = props['RTE_DESC']
        route.dir_desc = props['DIR_DESC']
        route.dir = props['DIR'].to_i
        route.geo = r['geometry']
        route.save
      end
      TransitRoute.ensure_index(:rte)
      TransitRoute.ensure_index(:type)
      
    end
  end
  #   desc 'Import Trimet Bus, Max, and Streetcar Stops'
  #   task :routes => :environment do
  #     raise "Already Imported Routes" if TrimetRoute.count < 0
  #     
  #     file = Pathname.new(Rails.root) + 'db' + 'data' + 'lightrail-routes.json'
  #     routes = JSON.parse(File.read(file))['features']
  #     
  #     routes.each do |r|
  #       props = r['properties']
  #       route = TrimetRoute.new
  #       route.type = props['TYPE'].downcase
  #       route.status = props['STATUS'].downcase
  #       route.tunnel = props['TUNNEL']
  #       route.line = props['LINE']
  #       route.length = props['LENGTH']
  #       route.geo = r['geometry']
  #       route.save
  #     end
  #     
  #     TrimetRoute.ensure_index([[:type, 1], [:status, 1]])
  #   end
  # end
  # 
  # desc 'Import Transit Bus, Max, and Streetcar Stops'
  # task :stops => :environment do
  #   file = Pathname.new(Rails.root) + 'db' + 'data' + 'trimet-stops.json'
  #   stops = JSON.parse(File.read(file))['features']
  #   
  #   stops.each do |s|
  #     props = s['properties']
  #     geo   = s['geometry']['coordinates']
  #     stop = TrimetStop.new(:stop_id => props['stop_id'])
  # 
  #     stop.name = props['stop_name']
  #     stop.jurisdiction = props['jurisdic']
  #     stop.zipcode = props['zipcode']
  #     stop.type = props['type'].downcase
  #     stop.loc = {'lat' => geo[0], 'lon' => geo[1]}
  #     stop.save
  #   end
  #   TrimetStop.ensure_index([[:loc, "2d"]])
  #   TrimetStop.ensure_index(:type)
  # end
end