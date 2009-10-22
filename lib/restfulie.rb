module Restfulie  
  alias :to_json_old :to_json
  def to_json
    to_json_old :methods => :acts
  end
  
  def to_xml(options = {})
    controller = options[:controller]
    if controller.nil?
      return to_xml_old
    end
    to_xml_old :skip_types => true do |xml|
      acts.each do |action|
        # direct link to action
        rel = action[:rel]
        rel = action[:action] if rel.nil?
        translate_href = controller.url_for(action)
        # xml.tag!('atom:link', 'xpto', 'abcd')
        xml.link :rel => rel, :href => translate_href
      end
    end
  end
end

module ActiveRecord::Serialization
  alias :to_xml_old :to_xml
end