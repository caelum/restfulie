require 'rubygems'
require 'restfulie'

# retrieves the list
resource = Restfulie.at("http://localhost:3000/items").accepts("application/xml").get

# picks the first item
basket = {"basket" => {"items" => [{"id" => resource.items.item.first["id"]}]}}

# creates the basket
resource = resource.items.links.basket.post! basket

# prepares the payment
payment = {"payment" => {"cardnumber" => "4850000000000001", "cardholder" => "guilherme silveira", :amount => resource.basket.price}}

# creates the payment
resource = resource.basket.links.payment.post! payment
