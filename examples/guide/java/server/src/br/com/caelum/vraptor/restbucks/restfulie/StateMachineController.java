package br.com.caelum.vraptor.restbucks.restfulie;

public interface StateMachineController<T> {

	public String getBaseUri();
	public T retrieve(String id);

}
