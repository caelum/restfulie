module Restfulie
  module Client
    module Base

      SELF_RETRIEVAL = [:latest, :refresh, :reload]
      
      # translates a response to an object
      def from_response(res)
      
        raise "unimplemented content type: #{res.content_type} '#{res.body}'" unless res.content_type=="application/xml"

        hash = Hash.from_xml res.body
        return hash if hash.keys.length == 0
        raise "unable to parse an xml with more than one root element" if hash.keys.length>1
      
        type = hash.keys[0].camelize.constantize
        type.from_xml(res.body)
      
      end
    
      def requisition_method_for(overriden_option,name)
        basic_mapping = { :delete => Net::HTTP::Delete, :put => Net::HTTP::Put, :get => Net::HTTP::Get, :post => Net::HTTP::Post}
        defaults = {:destroy => Net::HTTP::Delete, :delete => Net::HTTP::Delete, :cancel => Net::HTTP::Delete,
                    :refresh => Net::HTTP::Get, :reload => Net::HTTP::Get, :show => Net::HTTP::Get, :latest => Net::HTTP::Get}

        return basic_mapping[overriden_option.to_sym] if overriden_option
        defaults[name.to_sym] || Net::HTTP::Post
      end
      
      def is_self_retrieval?(name)
        name = name.to_sym if name.kind_of? String
        SELF_RETRIEVAL.include? name
      end
      
    end
  end
end
