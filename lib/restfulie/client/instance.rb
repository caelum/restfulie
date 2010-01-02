module Restfulie
  module Client
    module Instance
      
      # list of possible states to access
      def _possible_states
        @_possible_states ||= {}
      end

      # which content-type generated this data
      attr_accessor :_came_from
      
      def invoke_remote_transition(name, options, block)

        method = self.class.requisition_method_for options[:method], name

        state = self._possible_states[name]
        url = URI.parse(state["href"] || state[:href])
        req = method.new(url.path)
        req.body = options[:data] if options[:data]
        add_request_headers(req, name)
        
        response = Net::HTTP.new(url.host, url.port).request(req)

        return block.call(response) if block
        return response unless method == Net::HTTP::Get
        self.class.from_response response, self
      end
      
      private
      def add_request_headers(req, name)
        req.add_field("Accept", "application/xml") if self._came_from == :xml
        req.add_field("If-None-Match", self.etag) if self.class.is_self_retrieval?(name) && self.respond_to?(:etag)
        req.add_field("If-Modified-Since", self.last_modified) if self.class.is_self_retrieval?(name) && self.respond_to?(:last_modified)
      end

      public

  
      # inserts all transitions from this object as can_xxx and xxx methods
      def add_transitions(transitions)

        transitions.each do |t|
          self._possible_states[t["rel"] || t[:rel]] = t
          self.add_state(t)
        end
        self.extend Restfulie::Client::State
      end

    
      def add_state(transition)
        name = transition["rel"] || transition[:rel]
      
        # TODO: wrong, should be instance_eval
        self.class.module_eval do
        
          def temp_method(options = {}, &block)
            self.invoke_remote_transition(Restfulie::Client::Helper.current_method, options, block)
          end
        
          alias_method name, :temp_method
          undef :temp_method
        end
      end  

      # returns a list of extended fields for this instance.
      # extended fields are those unknown to this model but kept in a hash
      # to allow forward-compatibility.
      def extended_fields
        @hash ||= {}
        @hash
      end

      def method_missing(name, *args)
        name = name.to_s if name.kind_of? Symbol

        if name[-1,1] == "="
          extended_fields[name.chop] = args[0] 
        elsif name[-1,1] == "?"
          found = extended_fields[name.chop]
          return super(name,args) if found.nil?
          parse(found)
        else
          found = extended_fields[name]
          return super(name,args) if found.nil?
          parse(transform(found))
        end

      end

      # TODO test this guy
      def respond_to?(sym)
        extended_fields[sym.to_s].nil? ? super(sym) : true
      end

      # redefines attribute definition allowing the invocation of method_missing
      # when an attribute does not exist
      def attributes=(values)
        values.each do |key, value|
          unless attributes.include? key
            method_missing("#{key}=", value)
            values.delete key
          end
        end
        super(values)
      end


      # serializes the extended fields with the existing fields
      def to_xml(options={})
        super(options) do |xml|
          extended_fields.each do |key,value|
            xml.tag! key, value
          end
        end
      end

      private
      
      # transforms a value in a custom hash
      def transform(value)
        return CustomHash.new(value) if value.kind_of?(Hash) || value.kind_of?(Array)
        value
      end
      
      def parse(val)
        raise "undefined method: '#{val}'" if val.nil?
        val
      end


    end
  end
end
