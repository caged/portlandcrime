class CensusBlock
  include MongoMapper::Document
  
  key :props, Hash
  key :geo, Hash
  key :center, Hash
  
  ensure_index('props.geoid')
  ensure_index([[:center, "2d"]])
  
  
  def as_geojson(options = {})
    ret = {
      :id => id,
      :geometry => geo,
      :properties => props,
      :counts => {}
    }
    
    coors = geo['coordinates'][0]
    if options[:counts]
      ret[:counts][:total] = Crime.within_poly(coors).in_the_year(options[:year] || Time.now.year).count
      Offense.all.each do |of|
        cnt = Crime.within_poly(coors).in_the_year(options[:year] || Time.now.year).where(:code => of.code).count
        ret[:counts][of.code.to_sym] = cnt
      end
    end
    
    ret
  end
end