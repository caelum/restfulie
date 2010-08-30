require 'rubygems'
require 'rubygems/specification'
require 'rake'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rspec'
require File.expand_path('lib/restfulie')

GEM = "restfulie"
GEM_VERSION = Restfulie::VERSION
SUMMARY  = "Hypermedia aware resource based library in ruby (client side) and ruby on rails (server side)."
AUTHOR   = "Guilherme Silveira, Caue Guerra, Luis Cipriani, Everton Ribeiro, George Guimaraes, Paulo Ahagon"
EMAIL    = "guilherme.silveira@caelum.com.br"
HOMEPAGE = "http://restfulie.caelumobjects.com"

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = SUMMARY
  s.require_paths = ['lib']
  s.files = FileList['lib/**/*.rb', '[A-Z]*', 'lib/**/*.rng'].to_a
  s.add_dependency("nokogiri", [">= 1.4.2"])
  s.add_dependency("actionpack", [">= 2.3.2"])
  s.add_dependency("activesupport", [">= 2.3.2"])
  s.add_dependency("responders_backport", ["~> 0.1.0"])
  s.add_dependency("json_pure", [">= 1.2.4"])

  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
end

# optionally loads a task if the required gems exist
def optionally
  begin
    yield
  rescue LoadError; end
end

def start_server_and_invoke_test(task_name)
  IO.popen("ruby ./spec/units/client/fake_server.rb") do |pipe|
    wait_server(4567)
    Rake::Task[task_name].invoke
    Process.kill 'INT', pipe.pid
  end
end

def wait_server(port=3000)
  (1..15).each do 
    begin
      Net::HTTP.get(URI.parse("http://localhost:#{port}/"))
      return
    rescue
      sleep 1
    end
  end
  raise "Waited for the server but it did not finish"
end

desc 'Start server'
task :server do
  process 'fake_server' 
end

namespace :test do
  
  desc "Execute integration Order tests"
  task :integration do
    integration_path = "spec/integration/order/server"

    Dir.chdir(File.join(File.dirname(__FILE__), integration_path)) do
      system('rake db:drop db:create db:migrate')
      system('rake')
    end
  end
  
  task :spec do
    # spec_opts = ['--options', File.join(File.dirname(__FILE__) , 'spec', 'units', 'spec.opts')]
    RSpec::Core::RakeTask.new(:all) do |t|
      t.spec_files = FileList['spec/units/**/*_spec.rb']
      t.spec_opts = spec_opts
    end
    Spec::Rake::SpecTask.new(:common) do |t|
      t.spec_files = FileList['spec/common/**/*_spec.rb']
      t.spec_opts = spec_opts
    end
    Spec::Rake::SpecTask.new(:client) do |t|
      t.spec_files = FileList['spec/units/client/**/*_spec.rb']
      t.spec_opts = spec_opts
    end
    Spec::Rake::SpecTask.new(:server) do |t|
      t.spec_files = FileList['spec/units/server/**/*_spec.rb']
      t.spec_opts = spec_opts
    end
  end
  
  # namespace :rcov do
  #   Spec::Rake::SpecTask.new('rcov') do |t|
  #       t.spec_opts = %w(-fs --color)
  #       t.spec_files = FileList['spec/units/**/*_spec.rb']
  #       t.rcov = true
  #       t.rcov_opts = ["-e", "/Library*", "-e", "~/.rvm", "-e", "spec", "-i", "bin"]
  #     end
  #     desc 'Run coverage test with fake server'
  #     task :run do
  #       start_server_and_invoke_test('test:rcov:rcov')
  #     end
  # end
  
  namespace :run do
    task :all do
      start_server_and_invoke_test('test:spec:all')
      puts "Execution integration tests... (task test:integration)"
      Rake::Task["test:integration"].invoke()
      Rake::Task["test:examples"].invoke()
    end
    task :rcov do
      start_server_and_invoke_test('test:rcov:rcov')
    end
  end

  desc "runs all example tests"
  task :examples do
    Rake::Task["install"].invoke()

    target_dir = "full-examples/rest_from_scratch/part_3"
    system "cd #{target_dir} && rake db:reset db:seed"

    IO.popen("ruby #{target_dir}/script/server") do |pipe|
      wait_server
      system "cd #{target_dir} && rake spec"
      Process.kill 'INT', pipe.pid
    end

  end

end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Rake::RDocTask.new("rdoc") do |rdoc|
   rdoc.options << '--line-numbers' << '--inline-source'
end

optionally do
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/restfulie/**/*.rb', 'README.textile']
  end
end

desc "Install the gem locally"
task :install => [:package] do
  sh %{gem install pkg/#{GEM}-#{GEM_VERSION} -l}
end

desc "Create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

desc "Builds the project"
task :build => :spec

desc "Default build will run specs"
task :default => ['test:run:all']

