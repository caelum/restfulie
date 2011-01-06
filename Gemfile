source :gemcutter

gem "rack-conneg"
gem "sqlite3-ruby"
gem 'tokamak', ">= 1.0.0.beta4"
gem 'medie', ">= 1.0.0.beta4"
gem 'respondie', "~> 0.9.0"

if RUBY_VERSION < "1.9"
  gem "ruby-debug"
else
  gem "ruby-debug19", :require => "ruby-debug"
end

group :development do
  gem "yard"
end

group :test do  
  gem "rspec-rails", ">= 2.3.0"
  gem "rcov"
  gem "sinatra"
	gem "state_machine"
  gem "test-unit", "= 1.2.3"
	gem "fakeweb"
end  