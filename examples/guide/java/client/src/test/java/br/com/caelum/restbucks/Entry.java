package br.com.caelum.restbucks;

import static br.com.caelum.restbucks.model.Ordering.order;
import static br.com.caelum.restfulie.Restfulie.resource;

import java.net.URI;
import java.net.URISyntaxException;

import br.com.caelum.restbucks.model.Order;
import br.com.caelum.restbucks.model.Payment;
import br.com.caelum.restfulie.Relation;
import br.com.caelum.restfulie.Resources;
import br.com.caelum.restfulie.Response;
import br.com.caelum.restfulie.http.HttpMethod;

public class Entry {
	
	public static void main(String[] args) throws Exception {
		URI uri = processCommandLineArgs(args);
		happyPathTest(uri);
    }

    private static void happyPathTest(URI uri) throws Exception {

    	Resources resources = new MappingConfig().getServer();

        // Place the order
        System.out.println(String.format("About to start happy path test. Placing order at [%s] via POST", uri.toString()));
        Order order = createOrder();
        order = resources.entryAt(uri).post(order);
        
        System.out.println(String.format("Order placed at [%s]", order.getSelfUri()));
        
        // Pay for the order 
        Payment payment = new Payment("12345677878", "guilherme silveira", 12, 2999, order.getCost());
        System.out.println(String.format("About to create a payment resource at [%s] via PUT", resource(order).getRelation("payment").getHref()));
        payment =  order.pay(payment);
        System.out.println("Payment made, receipt created at: " + payment.getCreatedAt());

        // Check on the order status
        System.out.println(String.format("About to check order status at [%s] via GET", order.getSelfUri()));
        order = (Order) resource(order).getRelation("self").accessAndRetrieve();
        System.out.println(String.format("Final order placed, current status [%s]", order.getStatus()));
        
        // Allow the barista some time to make the order
        System.out.println("Pausing the client, press a key to continue");
        System.in.read();
        
        // Take the order if possible
        System.out.println(String.format("Trying to take the ready order from [%s] via DELETE. Note: the internal state machine must progress the order to ready before this should work, otherwise expect a 405 response.", order.getSelfUri()));
        order = (Order) resource(order).getRelation("self").accessAndRetrieve();
        Response finalResponse = resource(order).getRelation("retrieve").method(HttpMethod.DELETE).access();
        System.out.println(String.format("Tried to take final order, HTTP status [%d]", finalResponse.getCode()));
        if(finalResponse.getCode() == 200) {
            System.out.println(String.format("Order status [%s], enjoy your drink", finalResponse.getCode()));
        }
    }

	private static Order createOrder() {
		return order().withRandomItems().build();
	}
    

	/**
	 * Code from Jim Webber's restbucks example app
	 */
    private static URI processCommandLineArgs(String[] args) throws URISyntaxException {
        if(args.length != 1) {
            System.out.println("Must specify entry point URI as the only command line argument ");
            System.exit(1);
        } else {
            System.out.println("Binding to service at: " + args[0]);
        }
        return new URI(args[0]);
    }

}
