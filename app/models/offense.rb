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