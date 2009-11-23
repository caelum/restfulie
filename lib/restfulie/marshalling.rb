
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
      transition.add_link_to(xml, self, options)

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
