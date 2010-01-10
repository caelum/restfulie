module Restfulie
  module Client
    module Instance
      
      # list of possible states to access
      def _possible_states
        @_possible_states ||= {}
      end

      # which content-type generated this data
      attr_reader :_came_from
      
      # prepares a new request
      def request
        Restfulie::Client::RequestExecution.new(self.class, self)
      end
      
      def invoke_remote_transition(name, args, block = nil)
        
        data = nil
        if args.nil? || args.size==0
          options = {}
        elsif args.size==1
          if args[0].kind_of?(Hash)
            options = args[0]
          else
            data = args[0]
            options = {}
          end
        elsif args.size==2
          data = args[0]
          options = args[1] || {}
        end
        
        method = self.class.requisition_method_for options[:method], name

        state = self._possible_states[name]
        url = URI.parse(state["href"] || state[:href])
        req = method.new(url.path)
        
        options[:headers].each do |k, v|
          req.add_field(k, v)
        end if options[:headers]
        
        if data
          req.body = data
          req.add_field("Content-type", "application/xml") if req.get_fields("Content-type").nil?
        end
        
        add_request_headers(req, name)
        
        response = Net::HTTP.new(url.host, url.port).request(req)
        
        # TODO this should be calling RequestExecution... not parse
        Restfulie::Client::Response.new(self.class, response).parse(method, self, "application/xml")

      end
      
      private
      def add_request_headers(req, name)
        req.add_field("Accept", self._came_from) if req.get_fields("Accept")==["*/*"]
        req.add_field("If-None-Match", self.etag) if self.class.is_self_retrieval?(name) && self.respond_to?(:etag)
        req.add_field("If-Modified-Since", self.last_modified) if self.class.is_self_retrieval?(name) && self.respond_to?(:last_modified)
      end

      public

  
      # inserts all links from this object as can_xxx and xxx methods
      def add_transitions(links)
        links.each do |t|
          self._possible_states[t["rel"] || t[:rel]] = t
          self.add_state(t)
        end
        self.extend Restfulie::Client::State
      end

      # adds the specific information for one state change or related resource
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
