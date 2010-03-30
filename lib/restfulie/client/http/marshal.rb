#Request builder for marshalled data that unmarshalls content after receiving it.
module Restfulie::Client::HTTP

  module ResponseHolder
    attr_accessor :response
  end

  module RequestMarshaller
    include ::Restfulie::Client::HTTP::RequestBuilder

    @@representations = {
      'application/atom+xml' => ::Restfulie::Common::Representation::Atom
    }
    def self.register_representation(media_type,representation)
      @@representations[media_type] = representation
    end

    def accepts(content_type)
      @default_representation = @@representations[content_type]
      raise "Undefined representation for #{content_type}" unless @default_representation
      super
    end

    #Tells to return the raw content, instead of unmarshalling it.
    def raw
      @raw = true
      self
    end

    #Executes super and unmarshalls it
    def request!(method, path, *args)
      representation = do_conneg_and_choose_representation(method, path, *args)
      return super(method, path, *args) unless representation
      if has_payload?(method, path, *args)
        payload = get_payload(method, path, *args)
        payload = representation.marshal(payload)
        args = set_marshalled_payload(method, path, payload, *args)
      end
      args = add_representation_headers(method, path, representation, *args)
      response = super(method, path, *args)
      if @raw 
        response 
      else
        unmarshalled = representation.unmarshal(response.body)
        unmarshalled.extend(ResponseHolder)
        unmarshalled.response = response
        unmarshalled
      end
    end

    private

    def do_conneg_and_choose_representation(method, path, *args)
      #TODO make a request to server (conneg)
      representation = @default_representation || @default_representation = @@representations.values.first
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

