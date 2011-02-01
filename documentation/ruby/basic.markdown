## Hypermedia representations

<p>A Restful application should support hypermedia content, and following this constraint, a typical resource representing an order in xml would add controls (links or forms) so clients can navigate through your service protocol (in this case, make a payment):</p>

<p>
<code>
&lt;order xmlns:atom="
<a href='http://www.w3.org/2005/Atom'>
http://www.w3.org/2005/Atom
</a>
"&gt;
<br />
    &lt;product&gt;rails training&lt;/product&gt;
<br />
    &lt;product&gt;REST training&lt;/product&gt;
<br />
    &lt;price&gt;512.45&lt;/price&gt;
<br />
    &lt;atom:link rel="self" href="
<a href='http://www.caelum.com.br/orders/1'>
http://www.caelum.com.br/orders/1
</a>
" /&gt;
<br />
    &lt;atom:link rel="payment" href="
<a href='http://www.caelum.com.br/orders/1/payment'>
http://www.caelum.com.br/orders/1/payment
</a>
" /&gt;
<br />
&lt;/order&gt;
<br />
</code>
</p>

Here the order is represented through a typical application/xml file, but it has something extra: controls that allows clients to decide what to do next.
Or an <b>example</b> of a valid json representation with hypermedia:

<pre>
{ "order" : {
		"product" : "rails training",
		"product" : "rest training",
		"price" : "512.45"
		"links" : {
			"link" : { "rel" : "self", "href" : "http://www.caelum.com.br/orders/1"},
			"link" : { "rel" : "payment", "href" : "http://www.caelum.com.br/orders/1/payment"}
		}
	}
}
</pre>

Last of all, one could add the links on the Link header of the http response:

<pre>
<%= html 'Link: <http://www.caelum.com.br/orders/1>; rel="self", <http://www.caelum.com.br/orders/1/payment>; rel="payment"' %>
</pre>

## Server side

<p>This is a simple example how to make your controls available to your resource consumers. First configure your controller to respond to the media types you want to support, for example xml, json and atom:</p>

<pre>
class OrderController < ApplicationControl

	respond_to :json, :xml, :atom

	def show
		respond_with @order = Order.load(params[:id])
	end

end
</pre>

Now create a file called "show.tokamak" in the typical directory structure for view files on Rails. This file is a tokamak template that allows you to add
hypermedia controls:

<pre>
member(@order) do |member|  
  member.values do |value|
    value.id      @order.id
    value.price   @order.price
  end
  member.link "self", url_for @order
  member.link "payment", order_payment_url(@order)
end
</pre>

## Client side

<p>
	If you use Restfulie to access such a resource, there will be one entry point and all it's interactions will be driven by hypermedia links:<br/><br/>
	
<pre>
# retrieves the resource through GET: the entry point
response = Restfulie.at(resource_uri).get
order = response.resource

puts "Order price is #{order.price}"

# sends a post request to create a payment
order.links.payment.follow.post { :card => 4444, :amount => order.cost}

# sends a delete request to cancel the order
order.links.self.follow.delete
</pre>
</p>

<p>This should be all. Requesting the order with the header Accept or the extension xml should get you back a hypermedia supported xml file. With the json and atom versions everything should work accordingly.
	
	By now you should be able to put your resources online and hypermedia-link them whenever they make sense. Do not forget to use hypermedia controls to notify your client the URIs to use for creating and updating content too, as with the payment example above.</p>

</div>


