package br.com.caelum.restbucks.model;

import static br.com.caelum.restfulie.Restfulie.resource;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.annotations.XStreamOmitField;

@XStreamAlias("order")
public class Order {

	private String id;
	private Location location;
	
	private List<Item> items;

	private String status;
	private Payment payment;
	
	@XStreamAlias("created-at")
	private String createdAt;

	@XStreamAlias("updated-at")
	private String updatedAt;
	
	@XStreamOmitField
	private double cost;

	public enum Location {
		takeAway, drinkIn
	}

	public Order(String status, List<Item> items, Location location) {
		this.status = status;
		this.items = items;
		this.location = location;
	}

	public Order() {
		this.items = new ArrayList<Item>();
	}
	
	public void setLocation(Location location) {
		this.location = location;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public Payment getPayment() {
		return payment;
	}

	public void add(Item item) {
		this.items.add(item);
	}

	public String getSelfUri() {
		return resource(this).getRelation("self").getHref();
	}
	
	public Payment pay(Payment payment) {
		return resource(this).getRelation("payment").accessAndRetrieve(payment);
	}

	public void cancel() {
		resource(this).getRelation("cancel").access();
	}
	
	public double getCost() {
		return cost;
	}
	
}
