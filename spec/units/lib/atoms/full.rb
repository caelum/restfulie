# Revision: 3                                                                            #
collection(@materias) do |collection, materias|                                          # <feed xmlns="http://www.w3.org/2005/Atom" xmlns:materias="http://example.com.br">
                                                                                         #
  collection.values("xmlns:materias" => "http://example.com.br") do |values|             #
    values.id = "uri:materia:1"                                                          #   <id>uri:materia:1</id>
    values.title = "Materias"                                                            #   <title>Materias</title>
    values.updated = Time.now                                                            #   <updated>2010-05-03T16:29:26-03:00</updated>
                                                                                         #
    values.author {                                                                      #   <author>
      values.name  = "Éverton Ribeiro"                                                   #     <name>Éverton Antônio Ribeiro</name>
      values.email = "nuxlli@gmail.com"                                                  #     <email>nuxlli@gmail.com</email>
    }                                                                                    #   </author>
                                                                                         #
    values.author {                                                                      #   <author>                              
      values.name  = "Luis Felipe Cipriani"                                              #     <name>Luis Felipe Cipriani</name>
      values.email = "lfcipriani@gmail.com"                                              #     <email>lfcipriani@gmail.com</email>      
    }                                                                                    #   </author>
                                                                                         #
    values.dominio = "editorial"                                                         #   <materias:dominio>editorial</materias:dominio>
    values.count("xmlns" => "http://example.com.br") do                                  #   <count xmlns="http://example.com.br">
      values.materias = 1                                                                #     <materias>1</materias>
      values.albums = 1                                                                  #     <albums>1</albums>
    end                                                                                  #   </count>
  end                                                                                    #
                                                                                         #
  collection.members do |member, materia|                                                #   <entry xmlns:materias="http://example.com.br">
                                                                                         #
    member.values("xmlns:materias" => "http://example.com.br") do |values|               #
      values.id = "uri:1"                                                                #     <id>uri:1</id>
      values.title = "Materias 1"                                                        #     <title>Materia 1</title>
      # values.updated == materia.updated_at                                             #
                                                                                         #
      values.tag = materia.tags                                                          #     <materias:tag>tag1</materias:tag><materias:tag>tag2</materias:tag>
                                                                                         #
      values.criacao {                                                                   #     <materias:criacao>
        values.autor = "Luis Felipe Cipriani"                                            #       <materias:autor>Luis Felipe Cipriani</materias:autor>
        values.data_de_criacao = Time.now                                                #       <materias:data_de_criacao>2010-05-03T16:29:26-03:00</materias:data_de_criacao>
      }                                                                                  #     </materias:criacao>
                                                                                         #
      values.editorial(:editoria => "veja") do                                           #     <materias:editorial editoria="veja">
        values.categoria = "categoria 1, categoria 2"                                    #       <materias:cateoria>categoria 1, categoria 2</materias:cateoria>
      end                                                                                #     </materias:editorial>
                                                                                         #
      values.albums("xmlns:albums" => "http://example.com.br") do                        #     <albums:albums xmlns:albums="http://example.com.br">
        values.id = "uri:albums:1"                                                       #       <albums:id>uri:albums:1</albums:id>
        values.title = "Album 1"                                                         #       <albums:title>Album 1</albums:title>
      end                                                                                #     </albums:albums>
                                                                                         #
      # TODO : To be implemented soon                                                    #
      #values.albums("xmlns" => "http://example.com.br",                                 #     <albums xmlns="http://example.com.br" xmlns:song="http://example.com.br">
      #              "xmlns:song" => "http://example.com.br")  do                        #       
      #                                                                                  #       <id>1</id>
      #  values.id = 1                                                                   #       <song:title></song:title>
      #  values.song(:title, "")                                                         #     </albums>
      #end                                                                               #
    end                                                                                  #
                                                                                         #
    member.link(:href => "http://example.com/image/1", :rel => "image")                  #     <link href="http://example.com/image/1" rel="image" />
    member.link(:href => "http://example.com/image/2", :rel => "image",                  #     <link href="http://example.com/image/2" rel="image" type="application/atom+xml" />
         :type => "application/atom+xml")                                                #
  end                                                                                    #   </entry>
                                                                                         #
  collection.link(:href => "http://example.com/next", :rel => "next")                    #   <link href="http://example.com/next" rel="next" />
  collection.link(:href => "http://example.com/previous", :rel => "previous")            #   <link href="http://example.com/previus" rel="previous" />
       :type => "application/atom+xml")                                                  #
end                                                                                      # </feed>

