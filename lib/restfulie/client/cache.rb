class Restfulie::BasicCache
  
  
  
end

# Fake cache that does not cache anything
class Restfulie::FakeCache
  
  def put(url, req)
  end
  
  def get(url, req)
  end
  
end