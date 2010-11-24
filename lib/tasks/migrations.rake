# This is a temporary solution to migrations.  Look into mongrations or another 
# solution.

require 'name_map'
require 'csv'

namespace :migrations do
  desc 'Convert neighborhood names to normalized names and add geo data'
  task :one_normalize_neighborhood_names => :environment do
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
  end
  
  # Migration for noob mistake
  desc 'Correct improper neighborhood name imports'
  task :two_unify_same_neighborhoods => :environment do
    Neighborhood
    PDX_NHOODS_NAME_MAP.each do |k, v|
      
      # The crime importer wasn't swapped over to use the name map, so this needs
      # to be corrected by finding all neighborhoods in the name map and assigning
      # their crimes to the correct neighborhood
      nh = Neighborhood.first(:name => k)
      unless nh.nil?
        correct_nh = Neighborhood.first(:name => v.titlecase)
        if correct_nh.nil?
          puts "COULDN'T FIND #{v}"
        else
          nh.crimes.each do |c|
            c.neighborhood = correct_nh
            if c.save
              nh.destroy
            end
          end
        end
      end
    end
    
    
    # Now we need to find all neighborhoods that aren't in the name map, but 
    # have the exact same name (e.g. WOODSTOCK and Woodstock)

    Neighborhood.all.each do |nhood|
      count = Neighborhood.count(:name => /^#{nhood.name}$/i)
      if count >= 2 && !nhood.name.blank?
        correct = Neighborhood.first(:name => nhood.name.titlecase)
        duplicate = Neighborhood.first(:name => nhood.name.upcase)
        
        unless duplicate.nil?
          puts "Moving #{duplicate.crimes.count} from #{duplicate.name} to #{correct.name}"
          duplicate.crimes.each do |crime|
            crime.neighborhood = correct
            if crime.save
              duplicate.destroy
            end
          end
        else
          # For some reason we didn't find an upcased duplicate.  In that case, just pick one
          # and assign all crimes to it, deleting the dupes
          puts "UNABLE TO FIND PROPER DUP FOR #{correct.name}. Consolidating to one and deleting dupes."
          Neighborhood.all(:name => nhood.name.titlecase).each do |nh|
            nh.crimes.each do |c|
              c.neighborhood = correct
              c.save
              nh.destroy if nh != correct
            end
          end
        end
      end
    end
  end
  
  desc 'Import Neighborhood Demographic Data'
  task :three_import_neighborhood_demographics => :environment do
    data = File.join(Rails.root, 'db', 'data', 'neighborhood-demographics.csv')
    nhoods = CSV.read(data, :headers => true)
    Neighborhood.all.each do |n|
      found = nhoods.detect do |nh|
        n.name.downcase == nh['NEIGHBORHOOD'].downcase ||
        (PDX_DEMOGRAPHICS_NAME_MAP[n.permalink] && PDX_DEMOGRAPHICS_NAME_MAP[n.permalink].downcase == nh['NEIGHBORHOOD'].downcase)
      end
      
      if found
        props = found.to_hash
        props.delete('NEIGHBORHOOD')
        props.each do |k, v|
          props[k] = v.gsub(',', '').to_i
        end

        n.properties = props  
        if n.save
          puts "Imported demographics for #{n.name}"
        end
      end
    end

  end
end