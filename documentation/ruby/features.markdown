## Features

Most of the client features can be composed during the request building phase. This means that when invoking Restfulie.at one can specify which features are supposed to be used and which can be left out, allowing an infinite number of combinations without the need to write extra classes.
	
## Throw error feature

A common asked feature is to throw na error in case some specific response codes are returned. There is a sample feature that can be tweaked as required, that raises an exception when 300+ codes are returned. It's name is "ThrowError" and therefore to load it one only has to invoke it in the DSL:

`response = Restfulie.at(uri).throw_error.get`

## History

The history feature gives access to the history of executed requests, so one can re-execute it or customize it prior to sending the request again. To add it, simply load it into your DSL:

    result = Restfulie.at(uri).history.get
	
    # sends the request again
    result.request_history(0).get

## Retrying requests

Another characteristic of REST over HTTP is that some requests can be easily retried by adding a new feature to the DSL. The RetryWhenUnavailable feature demonstrates how to use it when the server returns 503. The following code will retry the operation once by using this feature:
	
    response = Restfulie.at(uri).retry_when_unavailable.get

## Custom features

It is easy to create your own feature, even with configuration parameters, simply create a class in the module Restfulie::Client::Feature
	

    # Adds support to whatever you want
    #
    # To use it, load it in your dsl:
    # Restfulie.at(uri).my_feature.get
    module Restfulie::Client::Feature
        class MyFeature

            def execute(chain, request, env)
			      
                # do something before the request is dispatched
                puts "requesting something to    {request.host}"
            
                # dispatch the request
                response = chain.continue(request, env)
            
                # do something after the request was executed
                puts "got back    {response.code}"
			
                response
            end
        end
    end


All Restfulie client features are implemented through a set of feature classes such as this one. Feel free to contribute with extra features, configuration sets or documentation to them or ask around in the mailing lists for other people contributions.
