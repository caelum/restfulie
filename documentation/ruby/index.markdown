## One minute guide

<p>This is a one minute guide to get you going with Restfulie Ruby.
	As soon as you finish this example you are up to the next guide and then
	move on to the features you want to explore more.</p>
	
## Configuring

Configuration should *always* be minimal and programmatic. To use Restfulie simply install its gem:

<pre>
gem install restfulie
</pre>

Or require it in your gemfile:

<pre>
require 'restfulie'
</pre>

## Server side configuration

In your controller, simply tell what is your resource and which representation media types you support. Notice how every feature is nothing but a one-liner:

<pre>
class ItemsController

	respond_to :xml, :json, :atom
	
	def index
		respond_with @items = Item.all
	end
	
	def show
		respond_with @item = Item.find(params[:id])
	end
end	
</pre>

## Hypermedia

Rail's webservices support through CRUD xml/json/atom is a nice easy to use feature. To move from webservices into the rest world, let's add some hyperlinks. Creating a template file called index.tokamak, one describes a representation's appearance:

<pre>
collection(@items, :root => "items") do |items|
  items.link "self", items_url

  items.members do |m, item|
    m.link :self, item_url(item)
    m.values { |values|
      values.name   item.name
    }
  end
end
</pre>

And our show.tokamak:

<pre>
member(@item) do |m|
  m.link "self", item_url(@item)
  m.values { |v|
    v.name @item.name
    v.price @item.price
  }
end
</pre>

We are ready to go, hypermedia supported:

<pre>
# using restfulie as an http api:
response = Restfulie.accepts("application/xml").
					at('http://localhost:8080/items').get
puts response.body
puts response.code

# unmarshalling the items response
items = response.resource
puts items.size
puts items[0].name

# navigating through hypermedia
item = { :name => "New product", :price => 30 }
result = items.link("self").follow.post item
puts result.code
</pre>

This is it. Adding hypermedia capabilities and following links. Now its time to use it in the <b>right way</b>.