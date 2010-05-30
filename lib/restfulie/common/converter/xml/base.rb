module Restfulie
  module Common
    module Converter
      module Xml
        module Base
          module ClassMethods
            mattr_reader :media_type_name
            @@media_type_name = 'application/xml'
        
            mattr_reader :headers
            @@headers = { 
              :post => { 'Content-Type' => media_type_name }
            }
        
            def marshal(entity, options = {})
              to_xml(entity, options)
            end
        
            def unmarshal(string)
              Hash.from_xml string
            end
        
            mattr_reader :recipes
            @@recipes = {}
        
            def describe_recipe(recipe_name, options={}, &block)
              raise 'Undefined recipe' unless block_given?
              raise 'Undefined recipe_name'   unless recipe_name
              @@recipes[recipe_name] = block
            end
        
            def to_xml(obj, options = {}, &block)
              return obj if obj.kind_of?(String)
              
              if block_given?
                recipe = block 
              elsif options[:recipe]
                recipe = @@recipes[options[:recipe]]
              elsif obj.kind_of?(Hash) && obj.size==1
                return obj.values.first.to_xml(:root => obj.keys.first)
              else
                return obj.to_xml
              end
              
              # Create representation and proxy
              builder = Builder.new(obj)
        
              # Check recipe arity size before calling it
              recipe.call(*[builder, obj, options][0,recipe.arity])
              builder.doc.to_xml
            end
            
            def helper
              Helpers
            end
          end
        end
      end
    end
  end
end 
