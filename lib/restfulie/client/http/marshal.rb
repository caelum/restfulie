#Request builder for marshalled data that unmarshalls content after receiving it.
module Restfulie::Client::HTTP

  module ResponseHolder
    attr_accessor :response
  end

  module RequestMarshaller
    include ::Restfulie::Client::HTTP::RequestHistory
    
    @@representations = {
      'application/atom+xml' => ::Restfulie::Common::Representation::Atom
    }
    def self.register_representation(media_type,representation)
      @@representations[media_type] = representation
    end

    def accepts(media_types)
      @default_representation = @@representations[media_types]
      super
    end

    def raw
      @raw = true
      self
    end

    def post!(payload,options={:recipe => nil})
      request!(:post, path, payload, options.merge(headers))
    end

    #Executes super if its a raw request, returning the content itself.
    #otherwise tries to parse the content with a mediatype handler or returns the response itself.
    def request!(method, path, *args)
      representation = do_conneg_and_choose_representation(method, path, *args)
      recipe_name = get_recipe_name(*args)
      return super(method, path, *args) if @raw
      return super(method, path, *args) unless representation
      if has_payload?(method, path, *args)
        payload = get_payload(method, path, *args)
        payload = representation.marshal(payload,recipe_name)
        args = set_marshalled_payload(method, path, payload, *args)
      end
      args = add_representation_headers(method, path, representation, *args)
      response = super(method, path, *args)
      unmarshalled = representation.unmarshal(response.body)
      unmarshalled.extend(ResponseHolder)
      unmarshalled.response = response
      unmarshalled
    end

    private

    def get_recipe_name(*args)
      headers_and_recipe_name = args.extract_options! 
      recipe_name = headers_and_recipe_name.delete(:recipe)
      args << headers_and_recipe_name
      recipe_name
    end
    
    def do_conneg_and_choose_representation(method, path, *args)
      #TODO make a conneg
      representation = @default_representation || @default_representation = @@representations.values.first
      representation
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
  class RequestMarshallerExecutor < RequestHistoryExecutor
    include RequestMarshaller
  end

end

