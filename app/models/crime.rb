class Crime
  include MongoMapper::Document
  
  key :case_id, Integer, :required => true
  key :reported_at, Time, :required => true
  key :district, Integer
  key :precinct, String
  key :address, String
  key :loc, Hash
  key :code, String
  
  timestamps!  
  
  belongs_to :offense      
  belongs_to :neighborhood
    
  scope :in_the_past, lambda {|time|   
    where(:reported_at.gte => Time.zone.now.change(:hour => 0) - time, 
    :reported_at.lt => Time.zone.now.change(:hour => 0)).sort(:reported_at.desc)}
  
  def as_json(options = {})
    props = attributes
    props.delete(:loc)
    {
      :type => 'Feature',
      :properties => props,
      :geometry => {
        :type => 'Point', 
        :coordinates => [loc['lat'], loc['lon']]
      }
    }
  end
  
  def self.number_of_crimes_per_each_month_from(start = Time.zone.now.beginning_of_year)
    map = "function() { emit(this.offense_id, { count: 0 }) }"
    red = <<-JS
      function(key, vals) {
        var sum = 0
        vals.forEach(function(val) { sum++ })
        return {count: sum}
      }
    JS
    Crime.collection.map_reduce(map, red, 
      :reported_at => {
        :$lt => Time.zone.now.change(:hour => 0).utc, 
        :$gte => Time.at(Time.zone.now.change(:hour => 0) - start)
      }).find.to_a
  end
# Validations :::::::::::::::::::::::::::::::::::::::::::::::::::::
# validates_presence_of :attribute

# Assocations :::::::::::::::::::::::::::::::::::::::::::::::::::::
# belongs_to :model
# many :model
# one :model

# Callbacks ::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
# before_create :your_model_method
# after_create :your_model_method
# before_update :your_model_method 

# Attribute options extras ::::::::::::::::::::::::::::::::::::::::
# attr_accessible :first_name, :last_name, :email

# Validations
# key :name, :required =>  true      

# Defaults
# key :done, :default => false

# Typecast
# key :user_ids, Array, :typecast => 'ObjectId'
  
   
end