# I don't really like where this is going.  Maybe there needs to be a bonafied gem 
# that handles geojson generation.
class Array
  def as_geojson(options = {})
    collect do |o|
      o.respond_to?(:as_geojson) ? o.as_geojson : o.to_json
    end
  end
end

Mime::Type.register "application/json", :geojson

ActionController.add_renderer :geojson do |json, options|
  json = json.respond_to?(:as_geojson) ? json.as_geojson : json
  json = {:type => 'FeatureCollection', :features => json}
  json = ActiveSupport::JSON.encode(json) unless json.respond_to?(:to_str)
  json = "#{options[:callback]}(#{json})" unless options[:callback].blank?
  self.content_type ||= Mime::GEOJSON
  self.response_body = json
end