require 'name_map'

namespace :migrations do
  desc 'Convert neighborhood names to normalized names and add geo data'
  task :normalize_neighborhood_names => :environment do
    nhoods = JSON.parse(File.read(File.join(Rails.root, 'db', 'data', 'neighborhoods.json')))
    
    Neighborhood.all.each do |n|
      cur_name = n.name.downcase
      nhood = nhoods['features'].detect { |f| f['properties']['NAME'].downcase == cur_name }
      if nhood.nil?
        name = PDX_NHOODS_NAME_MAP[n.name]
        unless name.nil?
          nhood = nhoods['features'].detect { |f| f['properties']['NAME'].downcase == name.downcase }
        end
      end
      
      unless nhood.nil?
        n.name = nhood['properties']['NAME'].titlecase
        n.geo = nhood['geometry']
        n.properties = nhood['properties']
        n.save
      end
    end
    # 
    # nhoods['features'].each do |nhood|
    #   props = nhood['properties']
    #   puts PDX_NHOODS_NAME_MAP[props['NAME']]
    #   exit
    # end
  end
end