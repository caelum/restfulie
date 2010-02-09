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
  
  module MediaType
    def self.HtmlType
      custom_type('html', DefaultMediaTypeDecoder, lambda {})
    end
    def self.TextHtmlType
      custom_type('text/html', DefaultMediaTypeDecoder, lambda {})
    end
  
    # TODO rename it and move it
    def self.default_types
      [Restfulie::MediaType.HtmlType,
        Restfulie::MediaType.TextHtmlType,
        rendering_type('application/xml', self),
        rendering_type('application/json', self),
        rendering_type('xml', self),
        rendering_type('json', self)]
    end
    
    # Default representations: every object can be serialized to those types
    def self.default_representations
      ['html','text/html','application/xml','application/json','xml','json']
    end

    # TODO should allow aliases...
    register(Restfulie::MediaType.HtmlType)
    register(Restfulie::MediaType.TextHtmlType)
    register(rendering_type('application/xml', DefaultMediaTypeDecoder))
    register(rendering_type('application/json', DefaultMediaTypeDecoder))
    register(rendering_type('xml', DefaultMediaTypeDecoder))
    register(rendering_type('json', DefaultMediaTypeDecoder))
  end
end
