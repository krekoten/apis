require 'multi_json'

module Apis
  module Middleware
    module Response
      class Json
        attr_accessor :app
        def initialize(app = nil)
          @app = app
        end

        def call(env)
          env.body = case env.body
          when ''
            nil
          when 'true'
            true
          when 'false'
            false
          else
            ::MultiJson.decode(env.body)
          end
          @app.call(env) if @app
        end
      end
    end
  end
end
