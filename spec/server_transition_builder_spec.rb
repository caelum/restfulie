require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Restfulie::Server::Transition do
  
  class GithubProject
    acts_as_restfulie
  end
  
  context "when creating a transition" do
    it "should create a transition with no status change and action+rel equals to the transition name" do
      GithubProject.new.respond_to?(:can_watch?).should be_false
      GithubProject.transition.watch
      GithubProject.new.respond_to?(:can_watch?).should be_true
      GithubProject.transitions.include?(:watch).should be_true
    end
    it "should create a transition with no status change and action+rel equals to the transition name" do
      result = :watching
      expected = mock Restfulie::Server::Transition
      expected.should_receive(:result=).with(result)
      Restfulie::Server::Transition.should_receive(:new).with(:watching).and_return(expected)

      GithubProject.new.respond_to?(:can_watching?).should be_false
      GithubProject.transition.watching.results_in(result)
      GithubProject.new.respond_to?(:can_watching?).should be_true
      GithubProject.transitions.include?(:watching).should be_true
    end
    it "should create a transition with no status change and action+rel equals to the transition name" do
      options = { :my_hash => :value }

      expected = mock Restfulie::Server::Transition
      expected.should_receive(:options=).with(options)
      Restfulie::Server::Transition.should_receive(:new).with(:watcher).and_return(expected)

      GithubProject.new.respond_to?(:can_watcher?).should be_false
      GithubProject.transition.watcher.at(options)
      GithubProject.new.respond_to?(:can_watcher?).should be_true
      GithubProject.transitions.include?(:watcher).should be_true
    end
  end
  
end