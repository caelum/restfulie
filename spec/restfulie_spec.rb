require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class RestfulieModel < ActiveRecord::Base
  def following_states
    "anything"
  end
end

describe RestfulieModel do
  context "when parsed to json" do
    it "should include the method following_states" do
      subject.to_json.should eql("{\"following_states\":\"#{subject.following_states}\"}")
    end
  end
end
