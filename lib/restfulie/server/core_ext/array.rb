module Restfulie
  module Server
    module CoreExtensions
      module Array

        def to_atom
          raise "Not all elements respond to to_atom" unless all? { |e| e.respond_to? :to_atom }
          options = {}
          options = options.dup
          options[:only_link] ||= false
        
          Atom::Feed.new do |feed|
            # TODO: Define better feed attributes
            # Array#to_s can return a very long string
            feed.title   = to_s
            feed.id      = hash
          
            each do |element|
              feed.entries << element.to_atom
            end
            
            yield feed if block_given?
          end
        end
    
      end
    end
  end
end