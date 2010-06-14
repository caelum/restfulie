rvm use 1.8.7-head
rvm gemset create restfulie-build
rvm gemset use restfulie-build
gem install bundler
bundle install
rake

