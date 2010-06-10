class Restfulie::Common::Representation::Maze < Restfulie::Common::Representation::XmlD

  @@media_type_name = 'application/vnd.amundsen.maze+xml'

  @@headers = { 
    :get  => { 'Accept'       => media_type_name },
    :post => { 'Content-type' => media_type_name }
  }

end

Mime::Type.register "application/vnd.amundsen.maze+xml", :maze
Restfulie::Client::HTTP::RequestMarshaller.register_representation("application/vnd.amundsen.maze+xml", Restfulie::Common::Representation::Maze)
