require 'pathname'
require 'pp'
require 'csv'
require 'name_map'

namespace :crime do
  desc 'Import new crimes from PDX Data Catalog.  Set YEAR to import specific year.  Defaults to current year.'
  task :import => :environment do
    year = ENV['YEAR'].nil? ? nil : ENV['YEAR'].strip
    
    url = 'http://www.portlandonline.com/shared/file/data/crime_incident_data'
    url += "_#{year}" unless year.nil?
    
    url = Pathname.new("#{url}.zip")
    out = Pathname.new(Rails.public_path) + 'data' + url.basename.to_s
    csv = out.sub(/\.zip$/, '.csv')
    csv = csv.sub(/\_#{year}/, '') unless year.nil?
    
    fork { exec "curl -f#LA 'PDXCrime v0.1' #{url.to_s} -o #{out.to_s}  #{'> /dev/null 2>&1' if Rails.env.production?}"; exit! 1 }
    Process.wait
    fork { exec "unzip -o #{out.to_s} -d #{out.dirname}"; exit! 1 }
    Process.wait
    
    FileUtils.rm(out)
    
    puts "\n\n"
        
    projection = Proj4::Projection.new('+proj=lcc +lat_1=44.33333333333334 +lat_2=46 +lat_0=43.66666666666666 +lon_0=-120.5 +x_0=2500000 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_def')
    i = 0
    start = Time.now
    
    begin
      CSV.foreach(csv) do |cr|
        if i != 0
          crime = Crime.first(:case_id => cr[0].to_i)
          if crime.nil?
            # Ruby 1.9 will not parse american date formats with the month first
            # so we do some hackery here to put the month first
            american = cr[1].split('/')
            month = american.shift
            american.insert(1, month)

            crime = Crime.new
            crime.case_id = cr[0]
            crime.reported_at = Time.zone.parse("#{american.join('/')} #{cr[2]}")
            crime.address = cr[4]
            crime.precinct = cr[6]
            crime.district = cr[7]
          
            # Convert points to WGS84 projection
            lat = cr[8].empty? ? 0 : cr[8]
            lon = cr[9].empty? ? 0 : cr[9]
            
            if lat == 0 || lon == 0
              crime.loc = {:lat => 0, :lon => 0}
            else
              point = Proj4::Point.new(lat.to_f, lon.to_f)
              wgs84 = projection.inverseDeg(point)
              crime.loc = {:lat => wgs84.x, :lon => wgs84.y}
            end

            # A little cleanup
            cr[3] = 'Simple Assault' if cr[3] == 'Assault, Simple'
          
            offense = Offense.first(:permalink => cr[3].parameterize)
            puts "\n\n #{cr[3]}" if offense.nil?
            crime.offense = offense
            crime.code = offense.code
          
            name = PDX_NHOODS_NAME_MAP[cr[5]].nil? ? cr[5] : PDX_NHOODS_NAME_MAP[cr[5]]
            nhood = Neighborhood.first_or_create(:name => name.titlecase, :permalink => name.parameterize)
            crime.neighborhood = nhood

            if !crime.save
              puts crime.errors.full_messages.join(", ")
            else
              i += 1
              puts "\c[[FImported #{i} Crimes. #{'%0.2f' % (Time.now - start)} seconds" unless Rails.env.production?
            end
          end
        end
        # Hack to ignore header row and reduce memory consuption when forced to 
        # create arrays from large CSV files
        i = 1 if i == 0  
      end
      puts "Imported #{i - 1} crimes in #{'%0.2f' % (Time.now - start)} seconds"
      ImportStatistic.create({:time_taken => Time.now - start, :crimes_imported => i - 1})
      
      # Remove the entire cache.  This is OK for now, but it won't last for ever.
      # Consider moving this to a sweeper?
      cache = File.join(Rails.public_path, 'cache')
      FileUtils.rm_r(cache) if File.exists?(cache)
    rescue Exception => e
      pp e.message
      pp e.backtrace
    end
    
    #FileUtils.rm(csv)
  end
end