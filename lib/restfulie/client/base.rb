class Hash
  def to_object(body)
    if keys.length>1
      raise "unable to parse an xml with more than one root element"
    elsif keys.length == 0
      self
    else
      type = keys[0].camelize.constantize
      type.from_xml(body)
    end
  end
end

module Restfulie

  # will execute some action in a specific URI
  def self.at(uri)
    Client::RequestExecution.new(nil, nil).at uri
  end
  
  module Client
    module Config

      def self.self_retrieval
        [:latest, :refresh, :reload, :self]
      end
  
      def self.requisition_method_for(overriden_option,name)
        basic_mapping = { :delete => Net::HTTP::Delete, :put => Net::HTTP::Put, :get => Net::HTTP::Get, :post => Net::HTTP::Post}
        return basic_mapping[overriden_option.to_sym] if overriden_option

        defaults = {:destroy => Net::HTTP::Delete, :delete => Net::HTTP::Delete, :cancel => Net::HTTP::Delete,
                    :refresh => Net::HTTP::Get, :reload => Net::HTTP::Get, :show => Net::HTTP::Get, :latest => Net::HTTP::Get, :self => Net::HTTP::Get}
        defaults[name.to_sym] || Net::HTTP::Post
      end
    
    end
    
    module Base

      def is_self_retrieval?(name)
        name = name.to_sym if name.kind_of? String
        Restfulie::Client::Config.self_retrieval.include? name
      end
    
    end
    
  end
end
