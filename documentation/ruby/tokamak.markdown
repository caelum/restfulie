## Rendering links with tokamak

Restfulie uses <a href="http://github.com/abril/tokamak">tokamak to render links</a> in media type representations. All documentation and samples from tokamak can be used in your tokamak templates.
	
## Sample

The following example shows how to render a collection using tokamak, to generate
a list of items and a link to both the collection and each one of the items:

    collection(@items, :root => "items") do |items|
        items.link "self", items_url

        items.members do |m, item|
            m.link :self, item_url(item)
            m.values { |values|
                values.name   item.name
            }
        end
    end
