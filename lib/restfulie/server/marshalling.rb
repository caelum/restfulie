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
  
  module Server
  
    module Marshalling
  
      # marshalls your object to json.
      # adds all links if there are any available.
      def to_json(options = {})
        Hash.from_xml(to_xml(options)).to_json
      end

      # marshalls your object to xml.
      # adds all links if there are any available.
      def to_xml(options = {})
        options[:skip_types] = true
        super options do |xml|
          links(options[:controller]).each do |link|
            if options[:use_name_based_link]
              xml.tag!(link[:rel], link[:uri])
            else
              xml.tag!('atom:link', 'xmlns:atom' => 'http://www.w3.org/2005/Atom', :rel => link[:rel], :href => link[:uri])
            end
          end
        end
      end
    end

  end  
end
