require 'net/http'

module Apis
  module Adapter
    class NetHTTP < Abstract
      def connection
        Net::HTTP.start(uri.host, uri.port)
      end

      def run(method, path, params = {}, headers = {})
        _module = Net::HTTP.const_get(method.to_s.capitalize)
        request = _module.new(path)
        response = connection.request(
          request,
          params.empty? ? nil : Addressable::URI.new.tap { |uri| uri.query_values = params }.query
        )
        [response.code.to_i] + response
      end

      Apis::Adapter.register :net_http, self
    end
  end
end
