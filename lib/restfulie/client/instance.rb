module Restfulie
  module Client
    module Instance
      
      # list of possible states to access
      attr_accessor :_possible_states

      # which content-type generated this data
      attr_accessor :_came_from
      
      
      def invoke_remote_transition(name, options, block)

        method = self.class.requisition_method_for options[:method], name

        url = URI.parse(_possible_states[name]["href"])
        req = method.new(url.path)
        req.body = options[:data] if options[:data]
        req.add_field("Accept", "application/xml") if _came_from == :xml

        response = Net::HTTP.new(url.host, url.port).request(req)

        return block.call(response) if block
        return response if method != Net::HTTP::Get
        self.class.from_response response
      end



    end
  end
end
