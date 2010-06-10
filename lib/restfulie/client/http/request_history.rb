module Restfulie
  module Client
    module HTTP #:nodoc:
      # ==== RequestHistory
      # Uses RequestBuilder and remind previous requests
      #
      # ==== Example:
      #
      #   @executor = ::Restfulie::Client::HTTP::RequestHistoryExecutor.new("http://restfulie.com") #this class includes RequestHistory module.
      #   @executor.at('/posts').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').get.code #=> 200 #first request
      #   @executor.at('/blogs').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').get.code #=> 200 #second request
      #   @executor.request_history!(0) #doing first request
      #
      module RequestHistory
        include RequestBuilder

        attr_accessor_with_default :max_to_remind, 10

        def snapshots
          @snapshots ||= []
        end

        def request!(method=nil, path=nil, *args)#:nodoc:
          if method == nil || path == nil 
            raise 'History not selected' unless @snapshot
            super( @snapshot[:method], @snapshot[:path], *@snapshot[:args] )
          else
            @snapshot = make_snapshot(method, path, *args)
            unless snapshots.include?(@snapshot)
              snapshots.shift if snapshots.size >= max_to_remind
              snapshots << @snapshot
            end
            super
          end
        end

        def request(method=nil, path=nil, *args)#:nodoc:
          request!(method, path, *args) 
        rescue Error::RESTError => se
          [[@host, path], nil, se.response]
        end

        def history(number)
          @snapshot = snapshots[number]
          raise "Undefined snapshot for #{number}" unless @snapshot
          self.host    = @snapshot[:host]
          self.cookies = @snapshot[:cookies]
          self.headers = @snapshot[:headers]
          self.default_headers = @snapshot[:default_headers]
          at(@snapshot[:path])
        end

        private

        def make_snapshot(method, path, *args)
          arguments = args.dup
          cutom_headers = arguments.extract_options!
          { :host            => self.host.dup,
            :default_headers => self.default_headers.dup,
            :headers         => self.headers.dup,
            :cookies         => self.cookies,
            :method          => method, 
            :path            => path,
            :args            => arguments << self.headers.merge(cutom_headers)   }
        end
      end
    end
  end
end
