require 'multi_json'

module Apis
  module Middleware
    module Response
      class Json
        APPLICATION_JSON = 'application/json'
        def initialize(app)
          @app = app
        end

        def call(env)
          env[:headers]['Accept'] = APPLICATION_JSON
          status, headers, body = @app.call(env)
          if headers['Content-Type'] && headers['Content-Type'].include?(APPLICATION_JSON)
            [status, headers, MultiJson.decode(body)]
          else
            [status, headers, body]
          end
        end
      end
    end
  end
end
