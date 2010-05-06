describe_collection(@materias) do |collection, materias|                        # <feed xmlns="http://www.w3.org/2005/Atom" xmlns:materias="http://example.com.br">
                                                                                #
  values(collection, "xmlns:materias" => "http://example.com.br") do |values|   #
    values.id = "uri:materia:1"                                                 #   <id>uri:materia:1</id>
    values.title = "Materias"                                                   #   <title>Materias</title>
    values.updated = Time.now                                                   #   <updated>2010-05-03T16:29:26-03:00</updated>
                                                                                #
    values.author {                                                             #   <author>
      values.name  = "Éverton Ribeiro"                                          #     <name>Éverton Antônio Ribeiro</name>
      values.email = "nuxlli@gmail.com"                                         #     <email>nuxlli@gmail.com</emal>
    }                                                                           #   </author>
                                                                                #
    values.author {                                                             #   <author>                              
      values.name  = "Luis Felipe Cipriani"                                     #     <name>Luis Felipe Cipriani</name>
      values.email = "lfcipriani@gmail.com"                                     #     <email>lfcipriani@gmail.com</emal>      
    }                                                                           #   </author>
                                                                                #
    values.dominio = 1                                                          #   <materias:dominio>editorial</materias:dominio>
    values.count("xmlns" => "http://example.com.br")                            #   <count xmlns="http://example.com.br">1</count>
  end                                                                           #
                                                                                #
  describe_member(collection) do |member, materia|                              #   <entry xmlns:materias="http://example.com.br">
                                                                                #
    values(member, "xmlns:materias" => "http://example.com.br") do |values|     #
      values.id = "uri:1"                                                       #     <id>uri:1</id>
      values.title = "Materias 1"                                               #     <title>Materia 1</title>
      # values.updated == materia.updated_at                                    #
                                                                                #
      values.tag = materia.tags                                                 #     <materias:tag>tag1</materias:tag><materias:tag>tag2</materias:tag>
                                                                                #
      values.criacao {                                                          #     <materias:criacao>
        values.autor = "Luis Felipe Cipriani"                                   #       <materias:autor>Luis Felipe Cipriani</materias:autor>
        values.data_de_criacao = Time.now                                       #       <materias:data_de_criacao>2010-05-03T16:29:26-03:00</materias:data_de_criacao>
      }                                                                         #     </materias:criacao>
                                                                                #
      values.editorial(:editoria => "veja") do                                  #     <materias:editorial editoria="veja">
        values.categoria = "categoria 1, categoria 2"                           #       <materias:cateoria>categoria 1, categoria 2</materias:cateoria>
      end                                                                       #     </materias:editorial>
                                                                                #
      values.albums("xmlns:albums" => "http://example.com.br") do               #     <materias:albums xmlns:albums="http://example.com.br">
        values.id = "uri:albums:1"                                              #       <albums:id>uri:albums:1</albums:id>
        values.title = "Album 1"                                                #       <albums:title>Album 1</albums:title>
      end                                                                       #     </materias:albums>
                                                                                #
    end                                                                         #
                                                                                #
    link(:href => "http://example.com/image/1", :rel => "image")                #     <link href="http://example.com/image/1" rel="image">
    link(:href => "http://example.com/image/2", :rel => "image",                #     <link href="http://example.com/image/2" rel="image" type="application/atom+xml">
         :type => "application/atom+xml")                                       #
  end                                                                           #   </entry>
                                                                                #
  link(:href => "http://example.com/next", :rel => "next")                      #   <link href="http://example.com/next" rel="next">
  link(:href => "http://example.com/previous", :rel => "previous")              #   <link href="http://example.com/previus" rel="previous">
       :type => "application/atom+xml")                                         #
end                                                                             # </feed>

