class Payment < ActiveRecord::Base
  belongs_to :basket
end
