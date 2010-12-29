module Medie
  class Link
    
    # allows you to follow links by using restfulie
    def follow
      r = Restfulie.at(href)
      r = r.as(content_type) if content_type
      r
    end
  end
end
