# A sample Gemfile
source :gemcutter
#
gem "rails", ">= 3.0.0"
gem "libxml-ruby"

gem "rack-conneg"
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
  gem "rspec-rails", ">= 2.0.0.beta.19"
#  gem "rspec-rails"
  gem "rcov"
  gem "sinatra"
	gem "state_machine"
  gem "test-unit", "= 1.2.3"
	gem "fakeweb"
end  