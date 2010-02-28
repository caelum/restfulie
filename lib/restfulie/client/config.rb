module Restfulie::Client::Config
  BASIC_MAPPING = { :delete => Net::HTTP::Delete, :put => Net::HTTP::Put, :get => Net::HTTP::Get, :post => Net::HTTP::Post}
  DEFAULTS = { :destroy => Net::HTTP::Delete, :delete => Net::HTTP::Delete, :cancel => Net::HTTP::Delete,
               :refresh => Net::HTTP::Get, :reload => Net::HTTP::Get, :show => Net::HTTP::Get, :latest => Net::HTTP::Get, :self => Net::HTTP::Get}

  def self.self_retrieval
    [:latest, :refresh, :reload, :self]
  end

  def self.requisition_method_for(overriden_option,name)
    return BASIC_MAPPING[overriden_option.to_sym] if overriden_option
    DEFAULTS[name.to_sym] || Net::HTTP::Post
  end
end