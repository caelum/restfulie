module Restfulie::Client

  module Base

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      include ::Restfulie::Client::HTTP::RequestBuilder

      attr_accessor :config

      def uses_restfulie(cnf = Configuration.new)
        @config = cnf
        yield cnf
        init(cnf.entry_point_host)
        at(config.entry_point_path)
      end

      def request!(method, path, *args)
        if config.default_headers and config.default_headers[method]
          custom_header = args.extract_options! 
          args << config.default_headers[method].merge(custom_header)
        end
        response = super(method, path, *args)
        response.unmarshal
      end

    end

    ::Restfulie::Client::HTTP::ResponseHandler.register(200,::Restfulie::Client::ResponseBodyHandler::Base)
  end

end

