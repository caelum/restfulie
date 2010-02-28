package br.com.caelum.vraptor.restbucks;

import javax.servlet.http.HttpServletResponse;

import br.com.caelum.travelandrest.Hotel;
import br.com.caelum.vraptor.config.Configuration;
import br.com.caelum.vraptor.interceptor.TypeNameExtractor;
import br.com.caelum.vraptor.ioc.Component;
import br.com.caelum.vraptor.ioc.RequestScoped;
import br.com.caelum.vraptor.restfulie.Restfulie;
import br.com.caelum.vraptor.restfulie.serialization.RestfulSerialization;

import com.thoughtworks.xstream.XStream;

@Component
@RequestScoped
public class XmlSerializer extends RestfulSerialization{

	public XmlSerializer(HttpServletResponse response,
			TypeNameExtractor extractor, Restfulie restfulie, Configuration config) {
		super(response, extractor, restfulie, config);
	}
	
	@Override
	protected XStream getXStream() {
		XStream instance = super.getXStream();
		instance.processAnnotations(Hotel.class);
		return instance;
	}

}
