module Restfulie  
  alias :to_json_old :to_json
  def to_json
    to_json_old :methods => :acts
  end
  
  def acts
    {:rel => actions[:rel], :href => "#{actions[:href][:controller]}/#{actions[:href][:action]}"}
  end
  
  def to_xml
    to_xml_old :skip_types => true do |xml|
      xml.link :rel => actions[:rel], :href => "#{actions[:href][:controller]}/#{actions[:href][:action]}"
    end
  end
end

module ActiveRecord::Serialization
  alias :to_xml_old :to_xml
end