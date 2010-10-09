ActionController.add_renderer :geojson do |json, options|
  json = {:type => 'FeatureCollection', :features => json}
  json = ActiveSupport::JSON.encode(json) unless json.respond_to?(:to_str)
  json = "#{options[:callback]}(#{json})" unless options[:callback].blank?
  self.content_type ||= Mime::JSON
  self.response_body = json
end