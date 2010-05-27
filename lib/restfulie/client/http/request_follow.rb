module Restfulie
  module Client
    module HTTP #:nodoc:
      #=RequestFollow follow new location of a document usually with response codes 201,301,302,303 and 307. You can also configure other codes.
      # 
      #==Example:
      # @executor = ::Restfulie::Client::HTTP::RequestFollowExecutor.new("http://restfulie.com") #this class includes RequestFollow module.
      # @executor.at('/custom/songs').accepts('application/atom+xml').follow(201).post!("custom").code
      module RequestFollow
        include RequestBuilder
  
        def follow(code)
          follow_codes << code unless follow_codes.include?(code)
          self
        end
  
        def request!(method, path, *args)#:nodoc:
          response = super
          if follow_codes.include?(response.code)
            location = response.headers['location'] || response.headers['Location']
            raise Error::AutoFollowWithoutLocationError.new(self, response) unless location
            self.host = location
            response = super(:get, self.path, headers)
          end
          response
        end
  
        protected
  
        def follow_codes
          @follow || @follow = [201,301,302,303,307]        
        end
      end
    end
  end
end
