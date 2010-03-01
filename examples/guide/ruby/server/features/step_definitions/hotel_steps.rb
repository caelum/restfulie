Given /^the following hotels exist:$/ do |hotels_table|
  @hotel_hash = hotels_table.hashes.first
end

When /^I create a resource using ([^\"]*)$/ do |content_type|
  # url = hotels_url
  url = "http://localhost:3000/hotels"
  @hotel = Restfulie.at(url).as(content_type).create(@hotel_hash.to_xml(:root => "hotel"))
end

Then /^the response should be valid$/ do
  @hotel.web_response.kind_of?(Net::HTTPResponse).should be_true
end

Then /^the hotel (\w+) should be "([^\"]*)"$/ do |field, body|
  @hotel.send(field.to_sym).should == body
end

Given /^they are saved in the database$/ do
  @model = Hotel.create(@hotel_hash)
end

When /^I request the hotel using ([^\"]*)$/ do |content_type|
  puts "#{hotels_url} vou usar #{content_type}"
  # url = hotels_url
  url = "http://localhost:3000/hotels"
  @hotel = Restfulie.at(url).accepts(content_type).get
  @hotel = Restfulie.at("#{url}/#{@model.id}").accepts(content_type).get
end

Then /^the response header "([^\"]*)" should be "([^\"]*)"$/ do |name, value|
  @hotel.web_response[name].should begin_with(value)
end

