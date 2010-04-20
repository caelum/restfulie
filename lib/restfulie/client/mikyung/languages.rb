module Restfulie::Client::Mikyung::German
  def Wenn(concat, &block)
    When(concat, &block)
  end
  def Und(concat, &block)
    And(concat, &block)
  end
  def Aber(concat, &block)
    But(concat, &block)
  end
  def Dann(concat, &block)
    Then(concat, &block)
  end
end

module Restfulie::Client::Mikyung::Portuguese
  def Quando(concat, &block)
    When(concat, &block)
  end
  def E(concat, &block)
    And(concat, &block)
  end
  def Mas(concat, &block)
    But(concat, &block)
  end
  def Entao(concat, &block)
    Then(concat, &block)
  end
end
