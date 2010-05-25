class Net::HTTP::Patch < Net::HTTP::Get
  METHOD = "PATCH"
end

# Definition of a patch method in the same way that post works
class Net::HTTP
  def patch(path, data, initheader = nil, dest = nil, &block) # :yield: +body_segment+
    res = nil
    request(Patch.new(path, initheader), data) {|r|
      r.read_body dest, &block
      res = r
    }
    unless @newimpl
      res.value
      return res, res.body
    end
    res
  end
end
