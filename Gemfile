# A sample Gemfile
source :gemcutter
#
gem "rails"
gem "libxml-ruby"

gem "rack-conneg"
gem "responders_backport"
gem "json_pure"
gem "sqlite3-ruby"
gem "yard"

if RUBY_VERSION < "1.9"
  gem "ruby-debug"
else
  gem "ruby-debug19", :require => "ruby-debug"
end

group :test do  
  gem "nokogiri"
  gem "rspec-rails"
  gem "rcov"
  gem "sinatra"
  gem "test-unit", "= 1.2.3"
end  

