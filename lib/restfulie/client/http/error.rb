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
#
module Restfulie::Client::HTTP

    module Error

      class BaseError < StandardError; end

      class TranslationError < BaseError; end

      class ServerNotAvailableError < StandardError; end

      class RESTError < StandardError

        attr_reader :response

        def initialize(method, path, response)
          @method = method.to_s.upcase
          @path = path
          @response = response
        end

        def to_s
          "HTTP error #{@response.code} when invoking #{::URI.decode(@path)} via #{@method}. " +
            ((@response.contents.blank?) ? "No additional data was sent." : "The complete response was:\n" + @response.contents)
        end

      end

      class UnknownError < RESTError;  end

      class Redirection < RESTError; end

      class ClientError < RESTError; end

      class BadRequest < ClientError; end

      class Unauthorized < ClientError; end

      class Forbidden < ClientError; end

      class NotFound < ClientError; end

      class MethodNotAllowed < ClientError; end

      class PreconditionFailed < ClientError; end

      class ProxyAuthenticationRequired < ClientError; end

      class Conflict < ClientError; end

      class Gone < ClientError; end

      class ServerError < RESTError; end

      class NotImplemented < ServerError; end

    end

end

