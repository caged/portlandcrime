class Demographic
  include MongoMapper::EmbeddedDocument         
  
  # The census data year
  key :year, Integer  
  key :properties, Hash
end