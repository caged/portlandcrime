xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0", 'xmlns:georss' => "http://www.georss.org/georss" do
  xml.channel do
    xml.title "Portland Crime | #{@neighborhood.name} Neighborhood"
    xml.description "Latest crime happening in the #{@neighborhood.name} neighborhood in Portland, Oregon."
    xml.link neighborhood_url(@neighborhood)
    
    @crimes.each do |crime|
      xml.item do
        xml.title "#{crime.offense.type['name']} / #{crime.offense.name}"
        xml.description crime.address
        xml.pubDate crime.reported_at.to_s(:rfc822)
        # Need individual crime pages before I can link this
        #xml.link neighborhood_url(@neighborhood) #{}"#{}/#18.00/#{crime.loc['lon'].to_f}/#{crime.loc['lat']}"
        xml.guid crime.id
        xml.tag! 'georss:point', "#{crime.loc['lat']},#{crime.loc['lon']}"
      end
    end
  end
end