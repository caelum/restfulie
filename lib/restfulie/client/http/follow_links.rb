module Restfulie
  module Client
    module HTTP #:nodoc:
      # ==== FollowLinks follow new location of a document usually with response codes 201,301,302,303 and 307. You can also configure other codes.
      # 
      # ==== Example:
      # @executor = ::Restfulie::Client::HTTP::FollowLinksExecutor.new("http://restfulie.com") #this class includes FollowLinks module.
      # @executor.at('/custom/songs').accepts('application/atom+xml').follow(201).post!("custom").code
      class FollowLinks < MasterDelegator
        
        def initialize(requester)
          @requester = requester
        end
  
        def follow(code = nil)
          @follow ||= true # turn on follow redirection
          follow_codes << code unless code.nil? or follow_codes.include?(code)
          self
        end
  
        def request!(method, path, *args)#:nodoc:
          begin
            response = super
          rescue Error::Redirection => e
            raise e unless @follow # normal behavior for bang methods is to raise the exception
            response = e.response
            if follow_codes.include?(response.code)
              location = response.headers['location'] || response.headers['Location']
              raise Error::AutoFollowWithoutLocationError.new(self, response) unless location
              self.host = location
              response = super(:get, location, headers)
            end
            response
          end
        end
  
        protected
  
          def follow_codes
            @follow_codes ||= [201,301,302,303,307]        
          end
      end
    end
  end
end
