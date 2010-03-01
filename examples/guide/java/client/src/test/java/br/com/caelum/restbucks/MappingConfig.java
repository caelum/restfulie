package br.com.caelum.restbucks;

import br.com.caelum.restbucks.model.Item;
import br.com.caelum.restbucks.model.Order;
import br.com.caelum.restbucks.model.Payment;
import br.com.caelum.restbucks.model.Receipt;
import br.com.caelum.restfulie.Resources;
import br.com.caelum.restfulie.Restfulie;

public class MappingConfig {

    private Resources server = Restfulie.resources();
    
    public MappingConfig() {
        server.configure(Order.class).include("items");
        server.configure(Payment.class);
        server.configure(Receipt.class);
        server.configure(Item.class);
    }

	public Resources getServer() {
		return server;
	}

}
