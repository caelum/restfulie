
## Opensearch

Restfulie client supports opensearch with both xml and json out of the box. Atom support can be included by adding a media type handler for atom.

## The media type handler

The opensearch media type handler comes from <a href="http://github.com/caelum/medie">medie</a> and allows unmarshalling an open search descriptor file, such as:

    description = Restfulie.at("http://localhost:3000/products/opensearch.xml")
        .accepts('application/opensearchdescription+xml').get.resource

And now, a description object can be searched by invoking the <b>use</b> method:

`items = description.use("application/xml").search(:searchTerms => what, :startPage => 1)`

There is a sample application <a href="https://github.com/caelum/restfulie-restbuy">showcasing open search usage on the client side at restfulie-restbuy</a>.

