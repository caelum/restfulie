# Content negotiation

## What is content negotation?

REST clients know how to deal with several different media types, for instance application/xml and application/opensearchdescriptor+xml. Being so, when requesting something to your service, a client tells which media types it is capable of understand so the service provides the best fit between the ones both of them are capable of handling.

![Content negotiation](http://restfulie.caelum.com.br/images/negotiation.png)

Content negotiation is the key concept that allows services to change their links to other parts of other systems while not breaking compatibility with their consumers (clients).

Because the new linked services supports a set of media types that so does your client, changes can be made and nothing breaks. 

## Client side content negotiation
	
By default, all Restfulie client requests will not add anything to the Accept header so the server is free to provide the representation using any media type:

    response = Restfulie.at('http://myhotels.caelum.com').get
    hotel = response.resource[0]
    puts "name: #{hotel.name}"


By executing the above code, the client is unaware of which media type was used. Typical clients <b>will</b> notify its client API (Restfulie) which media types it is capable of handling. The following source code shows how to add the Accept header with two options, json and xml:


response = Restfulie.accepts("application/xml").accepts("application/json").at('http://myhotels.caelum.com').get

    # print the media type used to produce the response
      puts response.headers["Content-type"]

      hotel = response.resource[0]
      puts "name: #{hotel.name}"


## Server side content negotiation
	
Restfulie in Ruby is built on top of Rails 3 responders and therefore you can tell which media types it supports by adding a respond_to invocation in your controller.

The following example shows how to respond to xml, json and atom in both index and show methods:

    class ItemsController
      respond_to :xml, :json, :atom
	    def index
        respond_with @items = Item.all
      end
      def show
        respond_with @item = Item.find(params[:id])
		  end
    end	

## Media types supported

Currently Restfulie supports the default xml, json, atom and opensearch representations. It also supports any profile or extension from such media types.

## Custom media types on the client side

To add support to a new media type, first create a class with two class methods, marshal and unmarshal that are invoked to serialize and deserialize the representation:


    class Medie.registry::FormUrlEncoded
        # marshals this content into a string to be posted/puted/patched
        def self.marshal(content, rel)
            if content.kind_of? Hash
        # transform_your_hash_into_string_here
                content.to_s
            else
                content
            end
        end

    # unmarshal this string into a ruby object
        def self.unmarshal(content)
            def content.links
                # if the media format supports hyperlinks
                # parse and return them
                []
		        end
            content
        end
    end


Finally, register your custom media type handler with Restfulie:

`Medie.registry.register 'application/opensearchdescription+xml', ::Medie.registry::OpenSearch`

If you create any new media type that can be shared, remember to contribute with Restfulie.

## Unnacepted

If the service does not understand the media type sent, it will return a 406 Unaccepted response. The client is responsible for checking the response status and act accordingly.

Restfulie goes ahead and provides something more. The ConnegWhenUnaccepted feature allows your clients to retry a request if the service did not accept the media type you tried to send.

The client will automatically check if any of the media types supported by the service (through the Accept respose header) is supported by the client itself, if so, it will re-send the response using the new media type.

This feature is turned off by default and can be linked in the chain of features by invoking it in your DSL:

`resource = Restfulie.at("http://localhost:3000/product/2").conneg_when_unaccepted.get`