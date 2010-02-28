package br.com.caelum.vraptor.restbucks;

import java.math.BigDecimal;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import br.com.caelum.travelandrest.Hotel;
import br.com.caelum.vraptor.ioc.ApplicationScoped;
import br.com.caelum.vraptor.ioc.Component;

/**
 * Simple database simulation.
 */
@Component
@ApplicationScoped
public class HotelDatabase {

	private static int total = 0;
	private Map<String, Hotel> orders = new HashMap<String, Hotel>();

	public HotelDatabase() {
	}

	public synchronized void save(Hotel hotel) {
		total++;
		String id = String.valueOf(total);
		hotel.setId(id);
		orders.put(id, hotel);
	}

	public void save(String id, Hotel hotel) {
		orders.put(id, hotel);
	}

	public boolean orderExists(String id) {
		return orders.containsKey(id);
	}

	private static final long serialVersionUID = 1L;

	public Hotel getOrder(String id) {
		return orders.get(id);
	}

	public Collection<Hotel> all() {
		return orders.values();
	}

	public void delete(Hotel hotel) {
		orders.remove(hotel.getId());
	}

	public void update(Hotel hotel) {
		orders.put(hotel.getId(), hotel);
	}

}
