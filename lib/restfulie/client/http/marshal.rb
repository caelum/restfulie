#Request builder for marshalled data that unmarshalls content after receiving it.
module Restfulie::Client::HTTP

  module ResponseHolder
    attr_accessor :response
    
    def respond_to?(symbol)
      super(symbol) || (super(:links) && respond_to_rel?(symbol.to_s))
    end
    
    private
    # whether this response contains specific relations
    def respond_to_rel?(rel)
      links.any? { |link| link.rel==rel }
    end
    
  end

  module RequestMarshaller
    include ::Restfulie::Client::HTTP::RequestBuilder
    
    # accepts a series of media types by default
    def initialize
    end

    @@representations = {
      'application/atom+xml' => ::Restfulie::Common::Representation::Atom
    }
    def self.register_representation(media_type,representation)
      @@representations[media_type] = representation
    end

    RequestMarshaller.register_representation('application/xml', ::Restfulie::Common::Representation::XmlD)
    RequestMarshaller.register_representation('text/xml', ::Restfulie::Common::Representation::XmlD)
    RequestMarshaller.register_representation('application/json', ::Restfulie::Common::Representation::Json)

    def self.content_type_for(media_type)
      return nil unless media_type
      content_type = media_type.split(';')[0] # [/(.*?);/, 1]
      type = @@representations[content_type]
      type ? type.new : nil
    end

    def accepts(media_types)
      @acceptable_mediatypes = media_types
      @default_representation = @@representations[media_types]
      raise "Undefined representation for #{media_types}" unless @default_representation
      super
    end

    def raw
      @raw = true
      self
    end

    #Executes super and unmarshalls it
    def request!(method, path, *args)
      
      if has_payload?(method, path, *args)
        payload = get_payload(method, path, *args)
        rel = self.respond_to?(:rel) ? self.rel : ""
        type = headers['Content-Type']
        raise Restfulie::Common::Error::RestfulieError, "Missing content type related to the data to be submitted" unless type
        marshaller = RequestMarshaller.content_type_for(type)
        payload = marshaller.marshal(payload, rel)
        args = set_marshalled_payload(method, path, payload, *args)
        args = add_representation_headers(method, path, marshaller, *args)
      end

      if @acceptable_mediatypes
        unmarshaller = RequestMarshaller.content_type_for(@acceptable_mediatypes)
        args = add_representation_headers(method, path, unmarshaller, *args)
      end

      response = super(method, path, *args) 
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
      elsif !response.body.empty?
        representation = RequestMarshaller.content_type_for(response.headers['content-type']) || Restfulie::Common::Representation::Generic.new
        unmarshalled = representation.unmarshal(response.body)
        unmarshalled.extend(ResponseHolder)
        unmarshalled.response = response
        unmarshalled
      else
        response
      end
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
      args.shift #old payload
      args << payload << headers
      args
    end

    def add_representation_headers(method, path, representation, *args)
      headers = args.extract_options!
      headers = headers.merge(representation.headers[method] || {})
      args << headers
      args
    end

  end

  # Gives to Link capabilities to fetch related resources.
  module LinkRequestBuilder
    include Restfulie::Client::HTTP::RequestMarshaller
    def path#:nodoc:
      at(href)
      as(content_type) if respond_to?(:content_type) && content_type
      super
    end
  end

  #=This class includes RequestBuilder module.
  class RequestMarshallerExecutor
    include RequestMarshaller

    # * <tt> host (e.g. 'http://restfulie.com') </tt>
    # * <tt> default_headers  (e.g. {'Cache-control' => 'no-cache'} ) </tt>
    def initialize(host, default_headers = {})
      self.host=host
      self.default_headers=default_headers
    end

    def at(path)
      @path = path
      self
    end
    def path
      @path
    end
  end

end
