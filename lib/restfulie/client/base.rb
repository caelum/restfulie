# == Retrieving resources
# 
# There is 2 ways to initially access a resource:
# * Using a class that includes Base module, which is more configurable:
# 
#     class Post                                                        
#       include Restfulie::Client::Base                                 
#                                                                   
#       uses_restfulie do |config|                                      
#         config.entry_point     = 'http://resource.entrypoint.com/post'
#         config.default_headers = {                                    
#           :get  => { 'Accept'       => 'application/atom+xml' },      
#           :post => { 'Content-Type' => 'application/atom+xml' }       
#         }                                                             
#       end                                                             
#     end
#     post = Post.get
#     post.title #=> "Hello world!"
# 
# * Directly accessing an entry point, without using any class: 
# 
#     post = Restfulie::Client::EntryPoint.at("http://resource.entrypoint.com/post").get
#     post.title #=> "Hello world!"
# 
# == Configuration
# 
# Check configuration options at Configuration class documentation.
module Restfulie::Client

  # 
  module EntryPoint
    include HTTP::Marshal::RequestBuilder
    extend self
  end

  module Base

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      include HTTP::Marshal::RequestBuilder

      attr_accessor :config

      def uses_restfulie(cnf = Configuration.new)
        @config = cnf
        yield cnf
        at(config.entry_point)
      end

      def request!(method, path, *args)
        if config.default_headers and config.default_headers[method]
          if self.default_headers
            self.default_headers = config.default_headers[method].dup.merge!( self.default_headers ) 
          else 
            self.default_headers = config.default_headers[method]
          end
        end
        super
      end

    end

  end

end

