module Restfulie::Client::HTTP
  
  # Adds support to extracting and navigating through a link in the representation header.
  module LinkHeader
    
    def links
      r = link_header_to_array
      Restfulie::Common::Converter::Xml::Links.new(r)
    end
    
    def link(rel)
      links[rel]
    end
        
    private

    def link_header_to_array
      links = self["link"][0].split(",")
      links.map do |link|
        string_to_hash(link)
      end
    end

    def string_to_hash(l)
      c = l[/<[^>]*/]
      uri = c[1..c.size]
      rest = l[/;.*/]
      rel = extract(rest, "rel")
      type = extract(rest, "type")
      { "href" => uri, "rel" => rel, "type" => type }
    end
    
    def extract(from, what)
      found = Regexp.new("#{what}=\"([^\"]*)\"").match(from)
      found ? found[1] : nil
    end

  end
end
