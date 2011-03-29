require 'rack/test'

module Apis
  module Adapter
    class RackTest < Abstract
      include Rack::Test::Methods

      attr_accessor :app

      attr_reader :last_path, :last_params, :last_headers

      def run(method, path, params = {}, headers = {})
        @last_path, @last_params, @last_headers = path, params, headers
        send(method, path, params, headers)
        [last_response.status, last_response.headers, last_response.body]
      end
    end
  end
end
