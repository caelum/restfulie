package br.com.caelum.travelandrest;

import java.util.Calendar;

import com.thoughtworks.xstream.annotations.XStreamAlias;

@XStreamAlias("hotel")
public class Hotel {

	private String name;
	private String city;
	
	@XStreamAlias("room-count")
	private int roomCount;
	private Calendar lastModifiedAt;
	private String id;
	
	private int rate;
	
	public void setId(String id) {
		this.id = id;
		modify();
	}

	private void modify() {
		this.lastModifiedAt = Calendar.getInstance();
	}
	
	public String getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public String getCity() {
		return city;
	}

	public int getRoomCount() {
		return roomCount;
	}
	
}
