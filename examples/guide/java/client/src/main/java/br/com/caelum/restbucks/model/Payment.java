package br.com.caelum.restbucks.model;

import java.math.BigDecimal;

import com.thoughtworks.xstream.annotations.XStreamAlias;

@XStreamAlias("payment")
public class Payment {
	
	private String id;

	@XStreamAlias("created-at")
	private String createdAt;

	@XStreamAlias("updated-at")
	private String updatedAt;

	@XStreamAlias("card-number")
	private String cardNumber;
    @XStreamAlias("cardholder-name")
	private String cardholderName;
    @XStreamAlias("expiry-month")
	private int expiryMonth;
    @XStreamAlias("expiry-year")
	private int expiryYear;
	private double amount;

	public Payment(String cardNumber, String cardholderName, int expiryMonth,
			int expiryYear, double amount) {
		super();
		this.cardNumber = cardNumber;
		this.cardholderName = cardholderName;
		this.expiryMonth = expiryMonth;
		this.expiryYear = expiryYear;
		this.amount = amount;
	}

	public String getCreatedAt() {
		return this.createdAt;
	}

}
