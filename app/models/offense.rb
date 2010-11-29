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
  
  before_create :generate_permalink_and_code
    
  def type_code
    type[:name].parameterize[0..1]
  end
  
  def to_param
    permalink
  end  
  
  private
    def generate_permalink_and_code
      self.permalink = name.parameterize if permalink.nil? || permalink.empty?      
      self.code = permalink[0..1]
    end
end