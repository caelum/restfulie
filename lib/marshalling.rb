
module Restfulie
  
  def to_json
    super :methods => :following_states
  end
  
  def add_links(xml, all, options)
    all.each do |result|
      add_link(result, xml, options)
    end
  end

  def add_link(result, xml, options) 

    result = self.class._transitions(result.to_sym) if result.class!=Restfulie::Transition

    if result.action
      action = result.action
      body = result.body
      action = body.call(self) if body

      rel = action[:rel] || result.name || action[:action]
      action[:rel] = nil
    else
      action = {}
      rel = result.name
    end

    action[:action] ||= result.name
    translate_href = options[:controller].url_for(action)
    if options[:use_name_based_link]
      xml.tag!(rel, translate_href)
    else
      xml.tag!('atom:link', 'xmlns:atom' => 'http://www.w3.org/2005/Atom', :rel => rel, :href => translate_href)
    end
  end

  def to_xml(options = {})
    
    return super unless respond_to?(:status)
    return super if options[:controller].nil?
    
    options[:skip_types] = true
    super options do |xml|
      all = all_following_transitions
      return super if all.empty?

      add_links xml, all, options
    end
  end

  def create_method(name, &block)
    self.class.send(:define_method, name, &block)
  end
  
end
