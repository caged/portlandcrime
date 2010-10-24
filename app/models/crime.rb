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
  
  add_concerns :reporting
    
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