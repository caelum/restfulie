module Restfulie  
  alias :to_json_old :to_json
  def to_json
    to_json_old :methods => :following_states
  end
  
  def to_xml(options = {})
    controller = options[:controller]
    return to_xml_old if controller.nil?
    
    use_name_based_link = options[:use_name_based_link]==true
    options[:skip_types] = true
    to_xml_old options do |xml|
      following_states.each do |action|
        rel = action[:rel]
        rel = action[:action] if rel.nil?
        translate_href = controller.url_for(action)
        xml.tag!('atom:link', 'xmlns:atom' => 'http://www.w3.org/2005/Atom', :rel => rel, :href => translate_href) unless use_name_based_link
        xml.tag!(rel, translate_href) if use_name_based_link
      end if respond_to?(:following_states)
    end
  end
end

module ActiveRecord::Serialization
  alias :to_xml_old :to_xml
end