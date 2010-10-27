database_config_file = File.join(Rails.root, "/config/database.mongo.yml")
yaml_content = File.read(database_config_file)
db_config = YAML::load(yaml_content)

if db_config[Rails.env] && db_config[Rails.env]['adapter'] == 'mongodb'
  # logfile = Logger.new("db.#{Rails.env}.log")
  mongo = db_config[Rails.env]
  MongoMapper.connection = Mongo::Connection.new(mongo['host'], nil, :logger => Rails.logger)
  MongoMapper.database = mongo['database']
  
  get_week_js = <<-JS
  function(date) {
    var a, b, c, d, e, f, g, n, s, w, $y, $m, $d;

    $y = (!$y) ? date.getFullYear() : $y;
    $m = (!$m) ? date.getMonth() + 1 : $m;
    $d = (!$d) ? date.getDate() : $d;

    if ($m <= 2) {
        a = $y - 1;
        b = (a / 4 | 0) - (a / 100 | 0) + (a / 400 | 0);
        c = ((a - 1) / 4 | 0) - ((a - 1) / 100 | 0) + ((a - 1) / 400 | 0);
        s = b - c;
        e = 0;
        f = $d - 1 + (31 * ($m - 1));
    } else {
        a = $y;
        b = (a / 4 | 0) - (a / 100 | 0) + (a / 400 | 0);
        c = ((a - 1) / 4 | 0) - ((a - 1) / 100 | 0) + ((a - 1) / 400 | 0);
        s = b - c;
        e = s + 1;
        f = $d + ((153 * ($m - 3) + 2) / 5) + 58 + s;
    }

    g = (a + b) % 7;
    d = (f + g - e) % 7;
    n = (f + 3 - d) | 0;

    if (n < 0) {
        w = 53 - ((g - s) / 5 | 0);
    } else if (n > 364 + s) {
        w = 1;
    } else {
        w = (n / 7 | 0) + 1;
    }

    $y = $m = $d = null;

    return w;
  }
  JS
  
  between_js = <<-JS
  function (date, start, end) {
    return date.getTime() >= start.getTime() && date.getTime() <= end.getTime();
  }
  JS
  javascript = <<-JS
    db.system.js.insert({_id:'getWeek', value : #{get_week_js} });
    db.system.js.insert({_id:'isBetweenTheHoursOf', value : #{between_js} });
  JS
  MongoMapper.database.eval(javascript)
end