package br.com.caelum.vraptor.restbucks;

import br.com.caelum.vraptor.ioc.ApplicationScoped;
import br.com.caelum.vraptor.ioc.Component;
import br.com.caelum.vraptor.restbucks.web.HotelController;
import br.com.caelum.vraptor.restfulie.controller.ResourceControl;

//@Component
//@ApplicationScoped
//public class OrderStateControl implements ResourceControl<Order> {
//	
//	private final HotelDatabase database;
//
//	public OrderStateControl(HotelDatabase database) {
//		this.database = database;
//	}
//	
//	@SuppressWarnings("unchecked")
//	public Class[] getControllers() {
//		return new Class[]{HotelController.class};
//	}
//	
//	public Order retrieve(String id) {
//		return database.getOrder(id);
//	}
//	
//}
