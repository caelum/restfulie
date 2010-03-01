rm -fr target
mkdir target

mkdir target/docs_ruby

sed -e '/\[tag java\]/,/\[\/tag java\]/ d' -e 's:\[tag ruby\]::' -e 's:\[/tag ruby\]::' < guide/1\ * > target/docs_ruby/1\ -\ configuring\ the\ server.afc
sed -e '/\[tag java\]/,/\[\/tag java\]/ d' -e 's:\[tag ruby\]::' -e 's:\[/tag ruby\]::' < guide/2\ * > target/docs_ruby/2\ -\ the\ travel\ agency\ system.afc
sed -e '/\[tag java\]/,/\[\/tag java\]/ d' -e 's:\[tag ruby\]::' -e 's:\[/tag ruby\]::' < guide/3\ * > target/docs_ruby/3\ -\ basic\ operations\ with\ hotels.afc
sed -e '/\[tag java\]/,/\[\/tag java\]/ d' -e 's:\[tag ruby\]::' -e 's:\[/tag ruby\]::' < guide/4\ * > target/docs_ruby/4\ -\ handling\ resources.afc
sed -e '/\[tag java\]/,/\[\/tag java\]/ d' -e 's:\[tag ruby\]::' -e 's:\[/tag ruby\]::' < guide/5\ * > target/docs_ruby/5\ -\ booking\ your\ trip.afc
sed -e '/\[tag java\]/,/\[\/tag java\]/ d' -e 's:\[tag ruby\]::' -e 's:\[/tag ruby\]::' < guide/6\ * > target/docs_ruby/6\ -\ transactions.afc
sed -e '/\[tag java\]/,/\[\/tag java\]/ d' -e 's:\[tag ruby\]::' -e 's:\[/tag ruby\]::' < guide/7\ * > target/docs_ruby/7\ -\ scaling\ our\ system.afc

mkdir target/docs_java

sed -e '/\[tag ruby\]/,/\[\/tag ruby\]/ d' -e 's:\[tag java\]::' -e 's:\[/tag java\]::' < guide/1\ * > target/docs_java/1\ -\ configuring\ the\ server.afc
sed -e '/\[tag ruby\]/,/\[\/tag ruby\]/ d' -e 's:\[tag java\]::' -e 's:\[/tag java\]::' < guide/2\ * > target/docs_java/2\ -\ the\ travel\ agency\ system.afc
sed -e '/\[tag ruby\]/,/\[\/tag ruby\]/ d' -e 's:\[tag java\]::' -e 's:\[/tag java\]::' < guide/3\ * > target/docs_java/3\ -\ basic\ operations\ with\ hotels.afc
sed -e '/\[tag ruby\]/,/\[\/tag ruby\]/ d' -e 's:\[tag java\]::' -e 's:\[/tag java\]::' < guide/4\ * > target/docs_java/4\ -\ handling\ resources.afc
sed -e '/\[tag ruby\]/,/\[\/tag ruby\]/ d' -e 's:\[tag java\]::' -e 's:\[/tag java\]::' < guide/5\ * > target/docs_java/5\ -\ booking\ your\ trip.afc
sed -e '/\[tag ruby\]/,/\[\/tag ruby\]/ d' -e 's:\[tag java\]::' -e 's:\[/tag java\]::' < guide/6\ * > target/docs_java/6\ -\ transactions.afc
sed -e '/\[tag ruby\]/,/\[\/tag ruby\]/ d' -e 's:\[tag java\]::' -e 's:\[/tag java\]::' < guide/7\ * > target/docs_java/7\ -\ scaling\ our\ system.afc
