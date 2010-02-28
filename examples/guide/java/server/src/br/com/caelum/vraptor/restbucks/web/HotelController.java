package br.com.caelum.vraptor.restbucks.web;

import static br.com.caelum.vraptor.view.Results.representation;
import br.com.caelum.travelandrest.Hotel;
import br.com.caelum.vraptor.Consumes;
import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Path;
import br.com.caelum.vraptor.Post;
import br.com.caelum.vraptor.Resource;
import br.com.caelum.vraptor.Result;
import br.com.caelum.vraptor.core.Routes;
import br.com.caelum.vraptor.restbucks.HotelDatabase;
import br.com.caelum.vraptor.view.Status;

/**
 * Hotel system mapped to a web resource.
 * 
 * @author guilherme silveira
 */
@Resource
public class HotelController {

	private final Result result;
	private final Status status;
	private final HotelDatabase database;
	private final Routes routes;

	public HotelController(Result result, Status status, HotelDatabase database, Routes routes) {
		this.result = result;
		this.status = status;
		this.database = database;
		this.routes = routes;
	}

	@Get
	@Path("/hotels/{hotel.id}")
	public void get(Hotel hotel) {
		hotel = database.getOrder(hotel.getId());
		if (hotel != null) {
			result.use(representation()).from(hotel).serialize();
		} else {
			status.notFound();
		}
	}
	
	@Post
	@Path("/hotels")
	@Consumes
	public void add(Hotel hotel) {
		database.save(hotel);
		routes.uriFor(HotelController.class).get(hotel);
		status.created(routes.getUri());
	}
	
	
}
