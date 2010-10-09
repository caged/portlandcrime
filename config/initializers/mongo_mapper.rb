database_config_file = File.join(Rails.root, "/config/database.mongo.yml")
yaml_content = File.read(database_config_file)
db_config = YAML::load(yaml_content)

if db_config[Rails.env] && db_config[Rails.env]['adapter'] == 'mongodb'
  # logfile = Logger.new("db.#{Rails.env}.log")
  mongo = db_config[Rails.env]
  MongoMapper.connection = Mongo::Connection.new(mongo['host'], nil, :logger => Rails.logger)
  MongoMapper.database = mongo['database']
end