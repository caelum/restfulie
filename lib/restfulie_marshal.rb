
module Restfulie
  def to_json
    super :methods => :following_states
  end
  
  def to_xml(options = {})
    return super unless respond_to?(:status)

    controller = options[:controller]
    return super if controller.nil?
        
    options[:skip_types] = true
    super options do |xml|
      possible_following = []
      default_transitions_map = self.class._transitions_for(status.to_sym)
      default_transitions = default_transitions_map[:allow] unless default_transitions_map.nil?
    
      possible_following += default_transitions unless default_transitions.nil?
      extra = self.following_transitions if self.respond_to?(:following_transitions)
      
      extra.each do |t|
        if t.class.name!="Array"
          possible_following << t
        else
          puts "There is an extra #{t}"
          transition = Transition.new(t[0], t[1], t[2])
          possible_following[transition.name] = t
        end
      end if extra
      
      return super if possible_following.empty?
      
      possible_following.each do |possible|
        if possible.class.name=="Array"
          name = possible[0]
          result = Transition.new(name, possible[1], nil, nil)
        else
          name = possible
          result = self.class._transitions(name.to_sym)
        end
        
        if result.action
          action = result.action
          body = result.body
          action = body.call(self) if body

          rel = action[:rel] || name || action[:action]
          action[:rel] = nil
        else
          action = {}
          rel = name
        end
    
        action[:action] ||= name
        translate_href = controller.url_for(action)
        if options[:use_name_based_link]
          xml.tag!(rel, translate_href)
        else
          xml.tag!('atom:link', 'xmlns:atom' => 'http://www.w3.org/2005/Atom', :rel => rel, :href => translate_href)
        end
      end
    end
  end

  def create_method(name, &block)
    self.class.send(:define_method, name, &block)
  end
  
end
