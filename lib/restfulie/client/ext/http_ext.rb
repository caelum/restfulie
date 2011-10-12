module Net
  class HTTP
    if not method_defined? :patch
      # Definition of a patch method in the same way that post works
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

    if not const_defined? :Patch
      class Patch < HTTPRequest
        METHOD = 'PATCH'
        REQUEST_HAS_BODY = true
        RESPONSE_HAS_BODY = true
      end
    end
  end
end

