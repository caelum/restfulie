
You can render your resource in any one of the following ways:

### render_resource
Will render the resource:
    
    def show
        @order = Order.find(params[:id])
	render_resource @order 
    end

If you want to pass an extra hash as options to the serializing function (to_xml, to_json, ...), you can do:

    def show
        @order = Order.find(params[:id])
        render_resource @order, { :exclude=> "paid_at"} 
    end

### render
You can render the resource with the typical render method:

    def show
        @order = Order.find(params[:id])
        render :resource => @order, :with => { :exclude=> "paid_at"}, :status => 201, :other_extra_key => :value
    end

### format
render_resource detects what the format is and is able to render xml, json, pretty much in the same way that respond_to works:

    def show
        @order = Order.find(params[:id])
        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render_resource @order, :except => [:paid_at] }
            format.json { render_resource @order, :except => [:paid_at] }
        end
    end
	
### Content type negotiation

The chosen media type to render will be selected between the formats available for your resource and your client's <b>Accepts</b> header. By default, <b>application/xml</b>, <b>application/json</b>, <b>text/html</b> and <b>application/xhtml</b> are available by default.

### Other media types

In order to support other media types, you can invoke your <b>media_types</b> method within your <b>ActiveRecord</b>:

    class Hotel < ActiveRecord::Base
        acts_as_restfulie
        media_type "vnd/caelum_hotel+xml", "vnd/caelum_hotel+json" # registering custom media types
    end

Note that the default media types are always registered for all your <b>ActiveRecord</b> that <b>acts_as_restfulie</b>.

### Rendering collections

If you render a resource collection, it will use the default media types available.

### etag support

When a client accesses a resource's representation for the first time, <b>Restfulie</b> automatically generates the etag from your resource as <b>etag = resource</b> and returns it to the client.

The client will then be able to send it back to the server when further working with this representation. Once the client sends the etag again, the server invocation to render_resource will use its value to check if the client cached representation is still valid. If it is, the server will return a 304 Not modified response and not render the response again.

Proxy servers staying between the client and the server might use the information provided by the server to lower even further the latency by not hitting the server if possible.

Server-side controller:

    def show
		    render_resource Order.find(params[:id])
    end

Server-side model:
    class Order < ActiveRecord::Base
        transition :self, {:action => :show}
    end

Client side usage:

    order =  Order.from_web uri # executes a GET request, receives the etag and last-modified
    puts order.price

    order = order.self # executes a GET, receives a 304
    puts order.price

You can also customize the etag generation process by implementing a custom value in your resource. In the following example the order etag will be calculated taking in account both itself and its payment: changes in the payment value will change the etag itself, invalidating the cache on the client side.

    class Order < ActiveRecord::Base
        def etag
            [self, payment]
        end
    end

### last modified

If your resource answers to the method *updated_at* (as ActiveRecord already does), its result will be used to set your resource's representation response header "Last modified". Pretty much as with the *etag*, the server will respond with a 304 Not modified if the resource last update matches the new client's request.
	
### rendering a resource after its creation

When a resource is created, a response code 201 should be returned with an optional representation of the created resource.

In order to do that, Restfulie allows you to invoke the <b>render_created</b> method:

    if @order.save
        render_created @order
		end

Render created will also set the Location response header to the resource retrieval location.

### Rendering collections as atom

See the atom section to know how to render resources and collections as atom.
