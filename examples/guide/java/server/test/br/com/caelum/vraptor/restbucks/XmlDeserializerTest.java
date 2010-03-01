package br.com.caelum.vraptor.restbucks;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

import org.junit.Test;

import br.com.caelum.travelandrest.Hotel;

import com.thoughtworks.xstream.XStream;

public class XmlDeserializerTest {
	
	private InputStream hotelXml() {
		return streamFor("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"+
		"<hotel>"+
		"  <id>510</id>"+
		"  <name>caelum</name>"+
		"  <city>sao paulo</city>"+
		"  <room_count>15</room_count>"+
		"</hotel>");
	}

	@Test
	public void shouldBeCapableOfDeserializingBasicData() {
		Hotel hotel = deserialize(hotelXml());
		assertThat(hotel.getId(), equalTo("510"));
		assertThat(hotel.getName(), equalTo("caelum"));
		assertThat(hotel.getCity(), equalTo("sao paulo"));
		assertThat(hotel.getRoomCount(), equalTo(15));
	}

	private Hotel deserialize(InputStream input) {
		XStream deserializer = createXStream();
		Hotel hotel = (Hotel) deserializer.fromXML(input);
		return hotel;
	}

	private XStream createXStream() {
		return new XmlDeserializer(null).getXStream();
	}
	
	private InputStream streamFor(String base) {
		return new ByteArrayInputStream(base.getBytes());
	}
}
