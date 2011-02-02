## State machine
The second way of defining your available transitions is to explicitely define the states and transitions.

By using this approach, one has to define a new column named <b>status</b> in a database migration file.

The first step involves defining all your states, each one with its own name and possible transitions, as:

`state :state_name, :allow => [ :first_transition_name, :second_transition_name]`

The following example shows all possible states for an order:

    class Order < ActiveRecord::Base

        acts_as_restfulie

        state :unpaid, :allow => [:latest, :pay, :cancel]
        state :cancelled, :allow => :latest
        state :received, :allow => [:latest, :check_payment_info]
        state :preparing, :allow => [:latest, :check_payment_info]
        state :ready, :allow => [:latest, :receive, :check_payment_info]
    end

Now its time to define which controller and action each transition invokes, in a much similar way to
the transition definitions in the following_transitions method:

    class Order < ActiveRecord::Base
    end

Once a transition has been given a name, its name can be used in the following_transitions method also.
The next example does not configure the transition because it was already defined, only adding it to the
list of available transition whenever the <b>can_pay?</b> method returns true:

    class Order < ActiveRecord::Base

        acts_as_restfulie do |order, transitions|
				    transitions << [:pay] if order.can_pay?
        end
				
				transition :pay, {:action => pay_this_order, :controller => :payments}, :preparing
    end

Note that whenever one defines a transition, there is a third - optional - argument, this is the
transition's target's state. Whenever the method <b>order.pay</b> method is invoked in the <b>server</b>, it will
automatically change the order's status to <b>preparing</b>.

You can download the server side example to see the complete code.

The last usage of the transition definition involves passing a block which receives the element in which
the transition URI's is required. The block should return all the necessary information for retrieving the URI, now having access to your element's instance variables:

    class Order < ActiveRecord::Base
        transition :check_payment_info do |order|
            {:controller => :payments, :action => :show, :order_id => order.id, 
						    :payment_id => order.payments[0].id, :rel => "check_payment_info"}
        end
    end

### Transitions DSL

In order to generate your transitions, you can use our new DSL:

This will generate a transition called "pay"

    class Order < ActiveRecord::Base
        transition.pay
    end

This will generate a transition called "pay" which end state is "paid"

    class Order < ActiveRecord::Base
        transition.pay.results_in(:paid)
    end

This will generate a transition called "pay" that uses the options given in the hash. This is specially useful when you want to change the action or controller used. Restfulie uses by default the controller with the same name of the model (in this example the default would be OrdersController), and the action with the same name of the transition (in this example would be pay).

    class Order < ActiveRecord::Base
        transition.pay.at(:controller => :payments, :action => :pay, :order_id => order.id)
		end

This is a more complete example

    class Order < ActiveRecord::Base
        transition.pay.at(:controller => :payments, :action => :pay, :order_id => order.id).results_in(:paid)
    end

This last example will generate the following xml:

    <order>
        <product>basic rails course</product>
        <product>RESTful training</product>
        <atom:link rel="pay" href="http://www.caelum.com.br/payments/1/pay" xmlns:atom="http://www.w3.org/2005/Atom"/>
    </order>

### Accessing all possible transitions

One can access all possible transitions for an object by invoking its available_transitions method:

`transitions = order.available_transitions`

### Checking the possibility of following transitions

By following the advanced usage, one receives also all <b>can_</b> method. i.e.:

    order.status = :unpaid
    puts(order.can_pay?)              # will print true
    order.status = :paid
    puts(order.can_pay?)              # will print false

You can use the <b>can_xxx</b> methods in your controllers to check if your current resource's state can be changed:

    def pay
        @order = Order.find(params[:id])
        raise "impossible to pay due to this order status #{order.status}" if !@order.can_pay?
   
        # payment code
    end
  
### Using xml+rel links instead of atom links

Atom is everywhere and can be consumed by a number of existing tools but if your system wants to supply its
services through commons rel+link xml as

    <order>
        <product>basic rails course</product>
        <product>RESTful training</product>
        <refresh>http://www.caelum.com.br/orders/1</refresh>
        <update>http://www.caelum.com.br/orders/1</update>
        <pay>http://www.caelum.com.br/orders/1/pay</pay>
        <destroy>http://www.caelum.com.br/orders/1</destroy>
    </order>

You can do it by passing the <b>use_name_based_link</b> argument:

`render_resource order :use_name_based_link => true`
