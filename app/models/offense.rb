class Offense
  include MongoMapper::Document    
  
  key :desc
  key :name
  key :permalink
  key :order, Integer
  key :type, Hash
  key :code
  timestamps!     

  many :crimes
  
  add_concerns :reporting
    
  def type_code
    type[:name].parameterize[0..1]
  end
  
  def to_param
    permalink
  end  
end