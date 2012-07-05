source :gemcutter

gemspec

group :development do
  gem "yard"
end

group :test do
  gem "rspec-rails", ">= 2.3.0"
  if RUBY_VERSION < "1.9"
    gem "rcov"
  else
    gem "simplecov"
  end
  gem "sinatra"
	gem "state_machine"
  gem "test-unit", "= 1.2.3"
	gem "fakeweb"
end