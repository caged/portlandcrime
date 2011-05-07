namespace :transit do
  namespace :import do
    desc 'Import Transit Routes'
    task :routes => :environment do
      file = Pathname.new(Rails.root) + 'db' + 'data' + 'transit_routes.json'
      routes = JSON.parse(file.read)['features']
      routes.each do |r|
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
 
    desc 'Import Bus, Max, and Streetcar Stops'
    task :stops => :environment do
      TransitStop.ensure_index(:stop_id)
      TransitStop.ensure_index(:rte)
      TransitStop.ensure_index([[:loc, "2d"]])
      TransitRoute.ensure_index([[:rte, 1], [:dir, 1]])
      TransitRoute.ensure_index(:rte)
      
      
      file = Pathname.new(Rails.root) + 'db' + 'data' + 'transit_route_stops.json'
      stops = JSON.parse(file.read)['features']

      stops.each_with_index do |s, i|
        props = s['properties']
        geo   = s['geometry']['coordinates']
        stop = TransitStop.first_or_new(:stop_id => props['STOP_ID'])
        route = TransitRoute.first(:rte => props['RTE'], :dir => props['DIR'])
        if route.nil?
          puts "#{stop.stop_id}/#{props['RTE']} #{props['RTE_DESC']} #{props['DIR_DESC']}"
        else
          stop.zipcode = props['ZIPCODE']
          stop.jurisdiction = props['JURISDIC']
          stop.name = props['STOP_NAME']
          stop.dir_desc = props['DIR_DESC']
          stop.rte_desc = props['RTE_DESC']
          stop.type = props['TYPE']
          stop.dir = props['DIR']
          stop.stop_seq = props['STOP_SEQ']
          stop.frequent = props['FREQUENT'].downcase == 'true' ? true : false
          stop.loc = {'lon' => geo[0], 'lat' => geo[1]}
          stop.routes << route
          route.stops << stop
          stop.save
          route.save
        end
      end
    end
  end
end