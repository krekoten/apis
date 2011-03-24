require 'net/http'

module Apis
  module Adapter
    class NetHTTP
      attr_accessor :uri
      def initialize(options = {})
        options.each do |key, value|
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

      def connection
        Net::HTTP.start(uri.host, uri.port)
      end

      # Performs request to resource
      # @param [Symbol, String] method HTTP method to perform
      # @param [String] path Relative path to resource host
      # @return [Array] headers, body
      def run(method, path, block = nil)
        _module = Net::HTTP.const_get(method.to_s.capitalize)
        request = _module.new(path)
        response = connection.request(request)
        [response.code.to_i] + response
      end

      Apis::Adapter.register :net_http, self
    end
  end
end
