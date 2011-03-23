$: << lib_dir unless $:.include?(lib_dir = File.expand_path('..', __FILE__))

module Apis
  class DuplicateMiddleware < StandardError; end
  autoload :Connection, 'apis/connection'
  autoload :Builder,    'apis/builder'

  module Adapter
    autoload :NetHTTP,    'apis/adapter/net_http'

    class << self
      def register(symbol, klass)
        @lookup_table ||= {}
        @lookup_table[symbol] = klass
      end

      def get_instance(symbol)
        @lookup_table ||= {}
        klass = @lookup_table[symbol]
        klass.new if klass
      end
    end
  end
end
