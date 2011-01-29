# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{restfulie}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Guilherme Silveira, Caue Guerra, Luis Cipriani, Everton Ribeiro, George Guimaraes, Paulo Ahagon, and many more!"]
  s.date = %q{2011-01-06}
  s.email = %q{guilherme.silveira@caelum.com.br}
  s.files = ["lib/restfulie/client/base.rb", "lib/restfulie/client/cache/basic.rb", "lib/restfulie/client/cache/fake.rb", "lib/restfulie/client/cache/http_ext.rb", "lib/restfulie/client/cache/restrictions.rb", "lib/restfulie/client/cache.rb", "lib/restfulie/client/configuration.rb", "lib/restfulie/client/dsl.rb", "lib/restfulie/client/entry_point.rb", "lib/restfulie/client/ext/http_ext.rb", "lib/restfulie/client/ext/link_ext.rb", "lib/restfulie/client/ext/open_search_ext.rb", "lib/restfulie/client/ext.rb", "lib/restfulie/client/feature/base.rb", "lib/restfulie/client/feature/rescue_exception.rb", "lib/restfulie/client/feature/base_request.rb", "lib/restfulie/client/feature/cache.rb", "lib/restfulie/client/feature/conneg_when_unaccepted.rb", "lib/restfulie/client/feature/enhance_response.rb", "lib/restfulie/client/feature/follow_request.rb", "lib/restfulie/client/feature/history.rb", "lib/restfulie/client/feature/history_request.rb", "lib/restfulie/client/feature/open_search/pattern_matcher.rb", "lib/restfulie/client/feature/open_search.rb", "lib/restfulie/client/feature/retry_when_unavailable.rb", "lib/restfulie/client/feature/serialize_body.rb", "lib/restfulie/client/feature/setup_header.rb", "lib/restfulie/client/feature/throw_error.rb", "lib/restfulie/client/feature/verb.rb", "lib/restfulie/client/feature.rb", "lib/restfulie/client/http/cache.rb", "lib/restfulie/client/http/error.rb", "lib/restfulie/client/http/link_header.rb", "lib/restfulie/client/http/response_holder.rb", "lib/restfulie/client/http.rb", "lib/restfulie/client/master_delegator.rb", "lib/restfulie/client/mikyung/concatenator.rb", "lib/restfulie/client/mikyung/core.rb", "lib/restfulie/client/mikyung/languages/german.rb", "lib/restfulie/client/mikyung/languages/portuguese.rb", "lib/restfulie/client/mikyung/languages.rb", "lib/restfulie/client/mikyung/rest_process_model.rb", "lib/restfulie/client/mikyung/steady_state_walker.rb", "lib/restfulie/client/mikyung/then_condition.rb", "lib/restfulie/client/mikyung/when_condition.rb", "lib/restfulie/client/mikyung.rb", "lib/restfulie/client/stack_navigator.rb", "lib/restfulie/client.rb", "lib/restfulie/common/error.rb", "lib/restfulie/common/logger.rb", "lib/restfulie/common.rb", "lib/restfulie/server/action_controller/base.rb", "lib/restfulie/server/action_controller/params_parser.rb", "lib/restfulie/server/action_controller/patch.rb", "lib/restfulie/server/action_controller/restful_responder.rb", "lib/restfulie/server/action_controller/trait/cacheable.rb", "lib/restfulie/server/action_controller/trait/created.rb", "lib/restfulie/server/action_controller/trait/save_prior_to_create.rb", "lib/restfulie/server/action_controller/trait.rb", "lib/restfulie/server/action_controller.rb", "lib/restfulie/server/configuration.rb", "lib/restfulie/server/controller.rb", "lib/restfulie/server/core_ext/array.rb", "lib/restfulie/server/core_ext.rb", "lib/restfulie/server/tokamak.rb", "lib/restfulie/server.rb", "lib/restfulie/version.rb", "lib/restfulie.rb", "Gemfile",  "LICENSE", "Rakefile", "README.textile"]
  s.homepage = %q{http://restfulie.caelumobjects.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.4.1}
  s.summary = %q{Hypermedia aware resource based library in ruby (client side) and ruby on rails (server side).}
  
  s.add_dependency("rack-conneg")
  s.add_dependency('tokamak', ">= 1.0.0.beta4")
  s.add_dependency('medie', ">= 1.0.0.beta4")
  s.add_dependency('respondie', "~> 0.9.0")
    
  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.2"])
      s.add_runtime_dependency(%q<json_pure>, [">= 1.2.4"])
      s.add_development_dependency("sqlite3-ruby")
    else
      s.add_dependency(%q<nokogiri>, [">= 1.4.2"])
      s.add_dependency(%q<json_pure>, [">= 1.2.4"])
      s.add_dependency("sqlite3-ruby")
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.4.2"])
    s.add_dependency(%q<json_pure>, [">= 1.2.4"])
    s.add_dependency("sqlite3-ruby")
  end
end
