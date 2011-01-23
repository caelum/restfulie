source :gemcutter

gemspec

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