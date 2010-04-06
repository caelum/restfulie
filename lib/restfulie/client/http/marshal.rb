#Request builder for marshalled data that unmarshalls content after receiving it.
module Restfulie::Client::HTTP

  module ResponseHolder
    attr_accessor :response
    
    def respond_to?(symbol)
      respond_to_rel?(symbol.to_s) || super(symbol)
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
    def intialize
      @acceptable_mediatypes = "application/atom+xml"
    end

    @@representations = {
      'application/atom+xml' => ::Restfulie::Common::Representation::Atom,
      'application/xml' => ::Restfulie::Common::Representation::XmlD
    }
    def self.register_representation(media_type,representation)
      @@representations[media_type] = representation
    end

    def accepts(media_types)
      debugger
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
      representation = do_conneg_and_choose_representation(method, path, *args)
      if representation
        if has_payload?(method, path, *args)
          payload = get_payload(method, path, *args)
          payload = representation.marshal(payload)
          args = set_marshalled_payload(method, path, payload, *args)
        end
        args = add_representation_headers(method, path, representation, *args)
      end
      response = super(method, path, *args) 
      parse_response(response, representation)
    end

    private
    
    # parses the http response.
    # first checks if its a 201, redirecting to the resource location.
    # otherwise check if its a raw request, returning the content itself.
    # finally, tries to parse the content with a mediatype handler or returns the response itself.
    def parse_response(response, representation)
      if response.code == 201
        location = response.headers['location']
        Restfulie.at(location).accepts(@acceptable_mediatypes).get!
      elsif @raw
        response
      elsif representation
        unmarshalled = representation.unmarshal(response.body)
        unmarshalled.extend(ResponseHolder)
        unmarshalled.response = response
        unmarshalled
      else
        response
      end
    end

    def do_conneg_and_choose_representation(method, path, *args)
      #TODO make a request to server (conneg)
      representation = @default_representation || @default_representation = @@representations['application/atom+xml']
      representation.new
    end

    def has_payload?(method, path, *args)
      [:put,:post].include?(method)
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
      args << representation.headers[method] 
      args
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

