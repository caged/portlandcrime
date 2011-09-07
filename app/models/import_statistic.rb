class ImportStatistic
  include MongoMapper::Document         

  timestamps!
  key :crimes_imported, Integer
  key :time_taken, Float
end