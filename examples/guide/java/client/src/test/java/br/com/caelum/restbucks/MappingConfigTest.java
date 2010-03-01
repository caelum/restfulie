package br.com.caelum.restbucks;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.io.StringWriter;
import java.util.ArrayList;

import org.junit.Test;

import br.com.caelum.restbucks.model.Item;
import br.com.caelum.restbucks.model.Order;
import br.com.caelum.restbucks.model.Order.Location;
import br.com.caelum.restfulie.Resources;

public class MappingConfigTest {
	
	@Test
	public void shouldBeAbleToUnderstandFields() {

		String content = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"+
	"<order>"+
	"  <created-at>2010-02-09T15:15:46Z</created-at>"+
	"  <id>360</id>"+
	"  <location>takeAway</location>"+
	"  <status>unpaid</status>"+
	"  <updated-at>2010-02-09T15:15:46Z</updated-at>"+
	"  <cost>20</cost>"+
	"  <items>"+
	"    <item>"+
	"      <created-at>2010-02-09T15:15:46Z</created-at>"+
	"      <drink>latte</drink>"+
	"      <id>784</id>"+
	"      <milk>semi</milk>"+
	"      <size>large</size>"+
	"      <updated-at>2010-02-09T15:15:46Z</updated-at>"+
	"      <atom:link href=\"http://localhost:3000/orders/360\" xmlns:atom=\"http://www.w3.org/2005/Atom\" rel=\"self\"/>"+
	"    </item>"+
	"    <item>"+
	"      <created-at>2010-02-09T15:15:46Z</created-at>"+
	"      <drink>latte</drink>"+
	"      <id>785</id>"+
	"      <milk>whole</milk>"+
	"      <size>medium</size>"+
	"      <updated-at>2010-02-09T15:15:46Z</updated-at>"+
	"      <atom:link href=\"http://localhost:3000/orders/360\" xmlns:atom=\"http://www.w3.org/2005/Atom\" rel=\"self\"/>"+
	"    </item>"+
	"  </items>"+
	"  <atom:link href=\"http://localhost:3000/orders/360\" xmlns:atom=\"http://www.w3.org/2005/Atom\" rel=\"self\"/>"+
	"  <atom:link href=\"http://localhost:3000/orders/360\" xmlns:atom=\"http://www.w3.org/2005/Atom\" rel=\"cancel\"/>"+
	"  <atom:link href=\"http://localhost:3000/orders/360/payment\" xmlns:atom=\"http://www.w3.org/2005/Atom\" rel=\"pay\"/>"+
	"  <atom:link href=\"http://localhost:3000/orders/360\" xmlns:atom=\"http://www.w3.org/2005/Atom\" rel=\"update\"/>"+
	"</order>";
		
    	Resources resources = new MappingConfig().getServer();
    	Order order = (Order) resources.getDeserializer().fromXml(content);
    	assertTrue(order!=null); // dumb test for config
	}

	@Test
	public void shouldSerializeSimpleOrder() {

		String expected = "<?xml version='1.0' encoding='utf-8'?>"+
	"<order>"+
	"<location>takeAway</location>"+
	"<items></items>"+
	"<status>unpaid</status>"+
	"</order>";
		
    	Resources resources = new MappingConfig().getServer();
    	Order order = new Order("unpaid", new ArrayList<Item>(), Location.takeAway);
    	StringWriter w  = new StringWriter();
    	resources.getSerializerFor(w, order).serialize();
    	assertEquals(expected, w.getBuffer().toString());
	}

}
