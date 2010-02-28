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
