require 'rack/test'

module Apis
  module Adapter
    class RackTest < Abstract
      include Rack::Test::Methods

      attr_accessor :app

      def run(method, path, params = {}, headers = {})
        send(method, path, params, headers)
        [last_response.status, last_response.headers, last_response.body]
      end
    end
  end
end
