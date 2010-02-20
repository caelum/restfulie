#
#  Copyright (c) 2009 Caelum - www.caelum.com.br/opensource
#  All rights reserved.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); 
#  you may not use this file except in compliance with the License. 
#  You may obtain a copy of the License at 
#  
#   http://www.apache.org/licenses/LICENSE-2.0 
#  
#  Unless required by applicable law or agreed to in writing, software 
#  distributed under the License is distributed on an "AS IS" BASIS, 
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
#  See the License for the specific language governing permissions and 
#  limitations under the License. 
#

require 'restfulie/client/extensions/http'

module Restfulie::Client

  # extension to all answers that allows you to access the web response
  module WebResponse
    attr_accessor :web_response
  end
  
  # some error ocurred while processing the request
  class ResponseError < Exception
  end
  
  # Handles response answered by servers by accessing the specific callback for a http response code.
  module ResponseHandler
    
    class << self

      # registers a new callback for a specific range of response codes
      #
      # Restfulie::Client::ResponseHandler.register(400, 599) do |restfulie_response|
      #   # returns the original reponse object
      #   restfulie_response.response
      # end
      def register(min_code, max_code, &block)
        (min_code..max_code).each do |code|
          handlers[code] = block
        end
      end

      # callback that parses the response media type and body,
      # returning a deserialized representation of the resource.
      # note that this will also set the _came_from instance variable with the content type
      # this resource was represented, in order to allow further requests to prefer this content type.
      def parse_entity(restfulie_response)
        response = restfulie_response.response
        response.content_type = "text/plain" unless response.content_type
        content_type = response.content_type
        result = coherce(content_type, restfulie_response, response)
        result.instance_variable_set :@_came_from, content_type
        result
      end
      
      # coherce the response into a specific type
      def coherce(to_type, restfulie_response, response)
        case unmarshaller_for(to_type)
        when "xml"
          Restfulie::MediaType.type_for(to_type).from_xml response.body
        when "json"
          Restfulie::MediaType.type_for(to_type).from_json response.body
        else
          generic_parse_entity restfulie_response
        end
      end
      
      # returns which type of unmarshaller should be used
      def unmarshaller_for(type)
        if type[-3,3]=="xml"
          "xml"
        elsif type[-4,4]=="json"
          "json"
        elsif type[-5,5]=="plain"
          "plain"
        else
          "generic"
        end
      end

      # callback that returns the http response object
      def pure_response_return(restfulie_response)
        restfulie_response.response
      end

      # callback that raises a ResponseError
      def raise_error(restfulie_response)
        raise Restfulie::Client::ResponseError.new(restfulie_response.response)
      end

      # given a restfulie response, extracts the response code and invoke the registered callback.
      def handle(restfulie_response)
        handlers[restfulie_response.response.code.to_i].call(restfulie_response)
      end
      
      def generic_parse_entity(restfulie_response)
        response = restfulie_response.response
        content_type = response.content_type[/(.*[\+\/])?(.*)/,2]
        type = Restfulie::MediaType.type_for(content_type)
        method = "from_#{content_type}".to_sym
        raise Restfulie::UnsupportedContentType.new("unsupported content type '#{content_type}' because '#{type}.#{method.to_s}' was not found") unless type.respond_to? method
        type.send(method, response.body)
      end

      # callback that parses the response media type and body,
      # returning a deserialized representation of the resource.
      # note that this will also set the _came_from instance variable with the content type
      # this resource was represented, in order to allow further requests to prefer this content type.
      def parse_entity(restfulie_response)
        response = restfulie_response.response
        content_type = response.content_type
        type = Restfulie::MediaType.type_for(content_type)
        if content_type[-3,3]=="xml"
          result = type.from_xml response.body
        elsif content_type[-4,4]=="json"
          result = type.from_json response.body
        else
          result = generic_parse_entity restfulie_response
        end
        result.instance_variable_set :@_came_from, content_type
        result
      end

      # callback taht executes a GET request to the response Location header.
      # this is the typical callback for 200 response codes.
      def retrieve_resource_from_location(restfulie_response)
        restfulie_response.type.from_web restfulie_response.response["Location"]
      end

      # given a restfulie response, extracts the response code and invoke the registered callback.
      def handle(restfulie_response)
        handlers[restfulie_response.response.code.to_i].call(restfulie_response)
      end
      
      def generic_parse_entity(restfulie_response)
        response = restfulie_response.response
        content_type = response.content_type
        type = Restfulie::MediaType.type_for(content_type)
        method = "from_#{content_type}".to_sym
        raise Restfulie::UnsupportedContentType.new("unsupported content type '#{content_type}' because '#{type}.#{method.to_s}' was not found") unless type.respond_to? method
        type.send(method, response.body)
      end

      private
      def handlers
        @handlers ||= {}
      end

      # gets a result object and enhances it with web response methods
      # by extending WebResponse and defining the attribute web_response
      def enhance(result)
        @response.previous = result.web_response if result.respond_to? :web_response
        result.extend Restfulie::Client::WebResponse
        result.web_response = @response
        Restfulie::Logger.logger.debug "Got a 405. Are you sure this is the correct method?" if @response.code=="405"
        result
      end
      
      def register_func(min, max, proc)
        register(min, max) { |r| proc.call(r) }
      end

    end
    
    register_func( 100, 599, Proc.new{ |r| pure_response_return r} )
    register_func( 200, 200, Proc.new{ |r| parse_entity r} )
    register_func( 301, 301, Proc.new{ |r| retrieve_resource_from_location r} )
    
  end

  
  # TODO there should be a response for each method type
  class Response
    
    attr_reader :type, :response
    
    def initialize(type, response)
      @type = type
      @response = response
    end

    # TODO remote_post can probably be moved, does not need to be on the object's class itself
    # the expected_content_type is used in case a redirection takes place
    def parse_post(expected_content_type)
      code = @response.code
      if code=="301" && @type.follows.moved_permanently? == :all
        result = @type.remote_post_to(@response["Location"], @response.body)
        enhance(result)
      elsif code=="201"
        Restfulie.at(@response["Location"]).accepts(expected_content_type).get
      else
        final_parse
      end
    end
    
    # gets a result object and enhances it with web response methods
    # by extending WebResponse and defining the attribute web_response
    def enhance(result)
      @response.previous = result.web_response if result.respond_to? :web_response
      result.extend Restfulie::Client::WebResponse
      result.web_response = @response
      result
    end
    
    # parses this response using the correct ResponseHandler and enhances it
    def final_parse
      enhance Restfulie::Client::ResponseHandler.handle(@response)
    end

    # detects which type of method invocation it was and act accordingly
    # TODO this should be called by RequestExcution, not instance
    def parse(method, invoking_object, content_type)

      return enhance(invoking_object) if @response.code == "304"

      # return block.call(@response) if block

      return final_parse if method == Net::HTTP::Get
      return parse_post(content_type) if method == Net::HTTP::Post
      final_parse
      
    end
    
  end

  class RequestExecution
    
    def initialize(type)
      initialize(type, nil)
    end

    def initialize(type, invoking_object)
      @type = type
      @content_type = "application/xml"
      @accepts = "application/xml"
      @invoking_object = invoking_object
    end

    def at(uri)
      @uri = uri
      self
    end
    
    # sets the Content-type AND Accept headers for this request
    def as(content_type)
      @content_type = content_type
      @accepts = content_type
      self
    end
    
    # sets the Accept header for this request
    def accepts(content_type)
      @accepts = content_type
      self
    end
    
    def with(headers)
      @headers = headers
      self
    end

    # asks to create this content on the server (post it)
    def create(content)
      post(content)
    end
    
    # executes an http request using the specified verb
    #
    # example:
    # do(Net::HTTP::Get, 'self', nil)
    # do(Net::HTTP::Post, 'payment', '<payment/>')
    def do(verb, relation_name, body = nil)
      Restfulie::Logger.logger.debug "sending a #{verb} to #{relation_name} with a #{body.class}"
      url, http_request = prepare_request(verb, relation_name, body)
      response = execute_request(url, http_request)
      Restfulie::Client::Response.new(@type, response).parse(verb, @invoking_object, "application/xml")
    end
    
    private
    def execute_request(url, http_request)
      cached = Restfulie::Client.cache_provider.get(url, http_request) 
      return cached if cached

      response = Net::HTTP.new(url.host, url.port).request(http_request)
      Restfulie::Client.cache_provider.put(url, http_request, response)
    end
    
    public
    
    def prepare_request(verb, relation_name, body = nil)
      url = URI.parse(@uri)
      req = verb.new(url.path)
      add_basic_request_headers(req, relation_name)
      
      if body
        req.body = body
        req.add_field("Content-type", "application/xml") if req.get_fields("Content-type").nil?
      end
      [url, req]
    end

    # post this content to the server
    def post(content)
      remote_post_to(@uri, content)
    end
    
    # retrieves information from the server using a GET request
    def get(options = {})
      from_web(@uri, options)
    end
    
    def add_headers_to(hash)
      hash[:headers] = {} unless hash[:headers]
      hash[:headers]["Content-type"] = @content_type
      hash[:headers]["Accept"] = @accepts
      hash
    end
    
    def change_to_state(name, args)
      if !args.empty? && args[args.size-1].kind_of?(Hash)
        add_headers_to(args[args.size-1])
      else
        args << add_headers_to({})
      end
      @invoking_object.invoke_remote_transition name, args
    end
    
    # invokes an existing relation or delegates to the existing definition of method_missing
    def method_missing(name, *args)
      if @invoking_object && @invoking_object.existing_relations[name.to_s]
        change_to_state(name.to_s, args)
      else
        super(name, args)
      end
    end

    def add_basic_request_headers(req, name = nil)
      
      req.add_field("Accept", @accepts) unless @accepts.nil?
      
      @headers.each do |key, value|
        req.add_field(key, value)
      end if @headers
      
      req.add_field("Accept", @invoking_object._came_from) if req.get_fields("Accept")==["*/*"]
      
      if @type && name && @type.is_self_retrieval?(name) && @invoking_object.respond_to?(:web_response)
        req.add_field("If-None-Match", @invoking_object.web_response.etag) if !@invoking_object.web_response.etag.nil?
        req.add_field("If-Modified-Since", @invoking_object.web_response.last_modified) if !@invoking_object.web_response.last_modified.nil?
      end
      
    end

    # invokes an existing relation or delegates to the existing definition of method_missing
    def method_missing(name, *args)
      if @invoking_object
        if @invoking_object.existing_relations[name.to_s]
          change_to_state(name.to_s, args)
        else
          Restfulie::Logger.logger.debug "Looking for a transition/relation named #{name} at #{invoking_object}, but didn't find it"
          super(name, args)
        end
      else
        super(name, args)
      end
    end

    private
    def remote_post_to(uri, content)
      
      url = URI.parse(uri)
      req = Net::HTTP::Post.new(url.path)
      req.body = content
      add_basic_request_headers(req)
      req.add_field("Content-type", @content_type)

      response = Net::HTTP.new(url.host, url.port).request(req)
      Restfulie::Client::Response.new(@type, response).parse_post(@content_type)
    end

    def from_web(uri, options = {})
      uri = URI.parse(uri)
      req = Net::HTTP::Get.new(uri.path)
      options.each { |key,value| req[key] = value }
      add_basic_request_headers(req)
      res = Net::HTTP.new(uri.host, uri.port).request(req)
      Restfulie::Client::Response.new(@type, res).final_parse
    end
    
  end
end
