class Restfulie::Common::Builder::CollectionRule < Restfulie::Common::Builder::Rules::Base
  attr_reader :members_blocks
  attr_reader :members_options
  
  def describe_members(options = {}, &block)
    @members_blocks  = block_given? ? [block] : []
    @members_options = options
  end
  
end