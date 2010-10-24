require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Restfulie::Common::Links do
  
  class RefreshieLinks
    include Restfulie::Common::Links
    def initialize(what)
      @what = what
    end
    def links
      RefreshieSelf.new(@what)
    end
  end

  class RefreshieSelf
    def initialize(what)
      @what = what
    end
    def self
      RefreshieFollow.new(@what)
    end
  end

  class RefreshieGet
    def initialize(what)
      @what = what
    end
    def get
      @what
    end
  end

  class RefreshieFollow
    def initialize(what)
      @what = what
    end
    def follow
      RefreshieGet.new(@what)
    end
  end

  it "should get self when refreshing itself" do
    RefreshieLinks.new("myself").refresh.should == "myself"
  end

end
