
module Restfulie
  
  module Marshalling
  
    def to_json
      super :methods => :following_states
    end
  
    # adds a link for each transition to the current xml writer
    def add_links(xml, all, options)
      all.each do |transition|
        add_link(transition, xml, options)
      end
    end

    # adds a link for this transition to the current xml writer
    def add_link(transition, xml, options) 

      transition = self.class.existing_transitions(transition.to_sym) unless transition.kind_of? Restfulie::Transition

      if transition.respond_to? :action
        action = transition.action
        body = transition.body
        action = body.call(self) if body

        rel = action[:rel] || transition.name || action[:action]
        action[:rel] = nil
      else
        action = {}
        rel = transition.name
      end
    
      puts "here we are"

      action[:action] ||= transition.name
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
  
end
