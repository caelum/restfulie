module Restfulie::Client::Feature
  module Base
  
    attr_reader :default_headers, :cookies, :verb, :host
    attr_writer :headers
  
    #Set host
    def at(url)
      if self.host.nil?
        self.host= url
      else
        self.host= self.host + url
      end
      self
    end

    #Set Content-Type and Accept headers
    def as(content_type)
      headers['Content-Type'] = content_type
      accepts(content_type)
    end

    #Set Accept headers
    def accepts(content_type)
      headers['Accept'] = content_type
      self
    end

    # Merge internal header
    #
    # * <tt>headers (e.g. {'Cache-control' => 'no-cache'})</tt>
    #
    def with(headers)
      self.headers.merge!(headers)
      self
    end

    # Path (e.g. http://restfulie.com/posts => /posts)
    def path
      host.path + (host.query.nil? ? "" : "?#{host.query}")
    end

    def host=(host)
      if host.is_a?(::URI)
        @host = host
      else
        @host = ::URI.parse(host)
      end
    end

    def default_headers
      @default_headers ||= {}
    end

    def headers
      @headers ||= {}
    end

    def http_to_s(method, path, *args)
      result = ["#{method.to_s.upcase} #{path}"]

      arguments = args.dup
      headers = arguments.extract_options!

      if [:post, :put].include?(method)
        body = arguments.shift
      end

      result << headers.collect { |key, value| "#{key}: #{value}" }.join("\n")

      (result + [body ? (body.inspect + "\n") : nil]).compact.join("\n") << "\n"
    end

  end
end
