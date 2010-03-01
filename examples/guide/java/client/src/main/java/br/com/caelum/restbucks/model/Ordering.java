package br.com.caelum.restbucks.model;

import br.com.caelum.restbucks.model.Item.Coffee;
import br.com.caelum.restbucks.model.Item.Milk;
import br.com.caelum.restbucks.model.Item.Size;
import br.com.caelum.restbucks.model.Order.Location;

public class Ordering {

	private final Order order = new Order();

	public static Ordering order() {
		return new Ordering();
	}

	public Ordering withRandomItems() {
		int quantity = random(2, 5);
		for (int i = 0; i < quantity; i++) {
			Item item = new Item(random(Coffee.class), random(Milk.class), random(Size.class));
			order.add(item);
		}
		return this;
	}

	private <T extends Enum> T random(Class<T> type) {
		return type.getEnumConstants()[random(0,type.getEnumConstants().length)];
	}

	private int random(int from, int to) {
		return (int) (Math.random() * (to-from) +from);
	}

	public Order build() {
		order.setLocation(random(Location.class));
		order.setStatus("unpaid");
		return this.order;
	}

}
