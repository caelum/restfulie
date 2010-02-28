package br.com.caelum.restbucks.model;

import java.math.BigDecimal;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.annotations.XStreamImplicitCollection;

@XStreamAlias("item")
public class Item {
	enum Coffee {
		latte(2.0), cappuccino(2.0), espresso(1.5);
		private final BigDecimal price;

		Coffee(double price) {
			this.price = new BigDecimal(price);
		}
	}

	enum Milk {
		skim, semi, whole
	};

	enum Size {
		small, medium, large
	};

	private String id;
	private Coffee drink;
	private Milk milk;
	private Size size;
	@XStreamAlias("created-at")
	private String createdAt;

	@XStreamAlias("updated-at")
	private String updatedAt;
	

	public Item(Coffee name, Milk milk, Size size) {
		this.drink = name;
		this.milk = milk;
		this.size = size;
	}

	public Coffee getDrink() {
		return drink;
	}

	public void setDrink(Coffee name) {
		this.drink = name;
	}

	public Milk getMilk() {
		return milk;
	}

	public void setMilk(Milk milk) {
		this.milk = milk;
	}

	public Size getSize() {
		return size;
	}

	public void setSize(Size size) {
		this.size = size;
	}

	public BigDecimal getPrice() {
		return drink.price;
	}

}
