$: << lib_dir unless $:.include?(lib_dir = File.expand_path('..', __FILE__))

module Apis
  class DuplicateMiddleware < StandardError; end
  autoload :Connection,       'apis/connection'
  autoload :ConnectionScope,  'apis/connection_scope'
  autoload :Builder,          'apis/builder'
  autoload :Response,         'apis/response'

  module Registerable
    def register(symbol, klass)
      @lookup_table ||= {}
      @lookup_table[symbol] = klass
    end

    def lookup(symbol)
      @lookup_table ||= {}
      self.const_get(@lookup_table[symbol])
    end
  end

  module Adapter
    autoload :Abstract,         'apis/adapter/abstract'
    autoload :NetHTTP,          'apis/adapter/net_http'
    autoload :RackTest,         'apis/adapter/rack_test'

    extend Registerable

    class << self
      # Default connection adapter
      # You can change it by assignin new value 
      def default
        @default ||= :net_http
      end
      attr_writer :default
    end

    register :net_http, :NetHTTP
    register :rack_test, :RackTest
  end

  module Middleware
    module Request
      extend Registerable
    end

    module Response
      autoload :Json,           'apis/middleware/response/json'

      extend Registerable

      register :json, :Json
    end
  end
end
