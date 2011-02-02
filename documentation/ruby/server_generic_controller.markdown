### A generic controller

Common resources will include CRUD, search and security features through the use of the appropriate HTTP verbs and characteritics.
In order to make it easier to deal with those cases, <b>Restfulie</b> has a custom generic controller that you can either inherit from or include its content into your own controller:

    class CitiesController < ApplicationController
        include Restfulie::Server::Controller
    end

### Automatic 404 support

For all single model related requests, a <b>404</b> response will be returned if the resource is not found.

### Inherited method: show<

The default <b>show</b> method will search for the resource and, if not found, return <b>404</b>.

If the resource is found, content negotiation takes place in order to render it according to the client preferences.

### Inherited method: delete

The default <b>delete</b> method will search for the resource and, if not found, return <b>404</b>.

If the resource is found, it will be deleted.

### Inherited method: create

The default <b>create</b> method will instantiate a model based on the request body string.

> Automatic creation does not support model creation based on request parameters if there is no body.

The instantiated resource will be saved and, if successful, return a <b>201</b> with the resource location as the <b>Location</b> header.

### Inherited method: update

The default <b>update</b> method will instantiate a model based on the request body string.

It will load the required resource and check if it can be updated by invoking the <b>can? :update</b> method. Your rest resource should contain such an option for its current state, as:

    class Order
        def acts_as_restfulie |order, t|
            t << [:update]
        end
    end

Update will return 415 if the content type does not match the ones understood by its model.

You can update your model prior to updating it by implementing a <b>pre_update</b>:

    class OrdersController
        def pre_update(model)
            model.status = "force_an_specific_status_prior_to_update"
        end
    end

### Cache info

You can override the entire caching behavior by implementing the method <b>cache_info</b> in your controller. Restfulie currently supports both etag and last modified values for such fields.

    def cache_info
        info = {:etag => self}
        info[:etag] = self.etag if self.respond_to? :etag
        info[:last_modified] = self.updated_at.utc if self.respond_to? :updated_at
        info
    end

