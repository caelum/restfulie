module Restfulie
  module Server
    module RailsExtensions
      module ActiveRecord       
        def to_atom(options={}, &block)         
          serializer = Restfulie::Server::Serializers::Atom.new(self, options={}, &block)
          block_given? ? serializer.atomify(&block) : serializer.atomify
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, Restfulie::Server::RailsExtensions::ActiveRecord)