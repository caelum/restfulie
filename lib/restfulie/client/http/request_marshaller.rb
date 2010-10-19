module Restfulie
  module Client
    module HTTP
      class RequestMarshaller < MasterDelegator

        def initialize(requester)
          @requester = requester
        end
        
        @@representations = {
          'application/atom+xml' => ::Restfulie::Common::Converter::Atom,
          'application/xml'      => ::Restfulie::Common::Converter::Xml,
          'text/xml'             => ::Restfulie::Common::Converter::Xml,
          'application/json'     => ::Restfulie::Common::Converter::Json
        }
        
        def self.register_representation(media_type,representation)
          @@representations[media_type] = representation
        end

        def self.content_type_for(media_type)
          return nil unless media_type
          content_type = media_type.split(';')[0] # [/(.*?);/, 1]
          @@representations[content_type]
        end
    
        def accepts(media_types)
          @default_representation = @@representations[media_types]
          delegate(:accepts, media_types)
        end
    
        def raw
          @raw = true
          self
        end
    
        # Executes super if its a raw request, returning the content itself.
        # otherwise tries to parse the content with a mediatype handler or returns the response itself.
        def request!(method, path, *args)      
          if has_payload?(method, path, *args)
            recipe = get_recipe(*args)
            
            payload = get_payload(method, path, *args)
            rel = self.respond_to?(:rel) ? self.rel : ""
            type = headers['Content-Type']
            raise Restfulie::Common::Error::RestfulieError, "Missing content type related to the data to be submitted" unless type
            marshaller = RequestMarshaller.content_type_for(type)
            payload = marshaller.marshal(payload, { :rel => rel, :recipe => recipe }) unless payload.nil? || (payload.kind_of?(String) && payload.empty?)
            args = set_marshalled_payload(method, path, payload, *args)
            args = add_representation_headers(method, path, marshaller, *args)
          end
    
          if @acceptable_mediatypes
            unmarshaller = RequestMarshaller.content_type_for(@acceptable_mediatypes)
            args = add_representation_headers(method, path, unmarshaller, *args)
          end
    
          key, req, response = delegate(:request, method, path, *args) 
          Restfulie::Client.cache_provider.put(key, req, response)

          parse_response(response)
        end
    
        private
        
        # parses the http response.
        # first checks if its a 201, redirecting to the resource location.
        # otherwise check if its a raw request, returning the content itself.
        # finally, tries to parse the content with a mediatype handler or returns the response itself.
        def parse_response(response)
          if response.code == 201
            request = Restfulie.at(response.headers['location'])
            request.accepts(@acceptable_mediatypes) if @acceptable_mediatypes
            request.get!
          elsif @raw
            response
          elsif (!response.body.nil?) && !response.body.empty?
            representation = RequestMarshaller.content_type_for(response.headers['content-type']) || Restfulie::Common::Representation::Generic.new
            representation.unmarshal(response.body).tap do |u|
              u.extend(ResponseHolder)
              u.response = response
            end
          else
            response.tap do |resp|
              resp.extend(ResponseHolder)
              resp.response = response
            end
          end
        end
    
        def get_recipe(*args)
          headers_and_recipe = args.extract_options! 
          recipe = headers_and_recipe.delete(:recipe)
          args << headers_and_recipe
          recipe
        end
    
        def has_payload?(method, path, *args)
          [:put,:post,:patch].include?(method)
        end
    
        def get_payload(method, path, *args)
          args.extract_options! #remove header
          args.shift #payload
        end
    
        def set_marshalled_payload(method, path, payload, *args)
          headers = args.extract_options!
          args.tap do |a|
            a.shift #old payload
            a << payload << headers
          end
        end
    
        def add_representation_headers(method, path, representation, *args)
          headers = args.extract_options!
          headers = headers.merge(representation.headers[method] || {})
          args << headers
          args
        end
      end
    end
  end
end
