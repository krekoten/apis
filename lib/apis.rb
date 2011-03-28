$: << lib_dir unless $:.include?(lib_dir = File.expand_path('..', __FILE__))

module Apis
  class DuplicateMiddleware < StandardError; end
  autoload :Connection,       'apis/connection'
  autoload :ConnectionScope,  'apis/connection_scope'
  autoload :Builder,          'apis/builder'

  module Adapter
    autoload :Abstract,         'apis/adapter/abstract'
    autoload :NetHTTP,          'apis/adapter/net_http'

    class << self
      # Default connection adapter
      # You can change it by assignin new value 
      def default
        @default ||= :net_http
      end
      attr_writer :default

      def register(symbol, klass)
        @lookup_table ||= {}
        @lookup_table[symbol] = klass
      end

      def lookup(symbol)
        @lookup_table ||= {}
        @lookup_table[symbol]
      end
    end
  end
end
