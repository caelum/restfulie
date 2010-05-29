module Restfulie
  module Common
    module Converter
      module Json
        module Base
          module ClassMethods
            mattr_reader :media_type_name
            @@media_type_name = 'application/json'
        
            mattr_reader :headers
            @@headers = { 
              :get  => { 'Accept'       => media_type_name },
              :post => { 'Content-Type' => media_type_name }
            }
        
            mattr_reader :recipes
            @@recipes = {}
        
            def describe_recipe(recipe_name, options={}, &block)
              raise 'Undefined recipe' unless block_given?
              raise 'Undefined recipe_name'   unless recipe_name
              @@recipes[recipe_name] = block
            end
      
            def to_json(obj = nil, options = {:root => {}}, &block)
              # just instantiate the string with the atom factory
              return Restfulie::Common::Representation::Json.create(obj) if obj.kind_of?(String)
              
              if block_given?
                recipe = block
              else
                recipe = options[:recipe]     
              end
              
              # Check if the object is already an json
              unless recipe
                return Restfulie::Common::Representation::Json.create(obj) if obj.kind_of?(Hash) || obj.kind_of?(Array)
                raise Restfulie::Common::Error::ConverterError.new("Recipe required")
              end
                      
              # Get recipe already described
              recipe = @@recipes[recipe] unless recipe.respond_to?(:call)
      
              # Create representation and proxy
              builder = Restfulie::Common::Converter::Json::Builder.new(obj, (options[:root] || {}))
      
              # Check recipe arity size before calling it
              recipe.call(*[builder, obj, options][0,recipe.arity])
      
              builder.representation
            end
            
            alias_method :unmarshal, :to_json
      
            def to_hash(obj)
              return obj if obj.kind_of?(Hash) || obj.kind_of?(Array)
              
              if obj.kind_of?(::String)
                Restfulie::Common::Representation::Json.create(obj)
              else
                raise Restfulie::Common::Error::ConverterError.new("It was not possible to convert this object to a Hash")
              end
            end
      
            def to_s(obj)
              return obj if obj.kind_of?(String)
              Restfulie::Common::Representation::Json.create(obj).to_s
            end
      
            def marshal(obj, options = nil)
              return obj if obj.kind_of? String
              to_json(obj, options).to_json
            end
            
            # returns the current helper
            def helper
              Helpers
            end
          end
        end
      end
    end
  end
end
