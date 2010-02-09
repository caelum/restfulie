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

module Restfulie
  module Client
    module Cache
      module Restrictions
        class << self

          # checks whether this request verb and its cache headers allow caching
          def may_cache?(request,response)
            may_cache_method?(request) && response.may_cache?
          end

          # only Post and Get requests are cacheable so far
          def may_cache_method?(verb)
            verb.kind_of?(Net::HTTP::Post) || verb.kind_of?(Net::HTTP::Get)
          end

        end

      end
    end
  end
end
