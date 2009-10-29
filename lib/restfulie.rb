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




module ActiveRecord
  class Base

    attr_accessor :_possible_states

    # basic code from Matt Pulver
    # found at http://www.xcombinator.com/2008/07/06/activerecord-from_json-and-from_xml/
    # addapted to support links
    def self.from_hash( hash )
      h = hash.dup
      links = nil
      h.each do |key,value|
          case value.class.to_s
          when 'Array'
            if key=="link"
              links = h[key]
              h.delete("link")
            else
              h[key].map! { |e|
                Object.const_get(key.camelize.singularize).from_hash e }
            end
           when 'Hash'
            h[key] = Object.const_get(key.camelize).from_hash value
          end
      end
      result = self.new h
      add_states(result, links) unless links.nil?
    end

    def self.add_states(result, states)
      result._possible_states = {}
      states.each do |state|
        result._possible_states[state["rel"]] = state
      end
      def result.respond_to?(sym)
        has_state(sym.to_s) || super(sym)
      end
      def result.has_state(name)
        return false if @_possible_states[name].nil?
        return true
      end

      def result.method_missing(name, *args, &block)
        return (puts "executei #{name}...") if has_state(name.to_s)
        super(name, *args, &block)
      end
      result
    end

    def self.from_json( json )
      hash = ActiveSupport::JSON.decode json
      self.from_hash hash
    end

    # The xml has a surrounding class tag (e.g. ship-to),
    # but the hash has no counterpart (e.g. 'ship_to' => {} )
    def self.from_xml( xml )
      hash = Hash.from_xml xml
      self.from_hash hash[self.to_s.underscore]
    end
  end
end

module ActiveRecord::Serialization
  alias :to_xml_old :to_xml
end
