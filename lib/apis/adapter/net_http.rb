require 'net/http'

module Apis
  module Adapter
    class NetHTTP
      def call(env)
        env[:url].path = '/' if env[:url].path.empty?
        http = Net::HTTP.new(env[:url].host, env[:url].port)
        query = Addressable::URI.new
        query.query_values = env[:params]
        response = case env[:method]
        when :GET
          http.get(env[:url].path, env[:headers])
        when :HEAD
          http.head(env[:url].path, env[:headers])
        when :POST
          http.post(env[:url].path, query.query, env[:headers])
        when :PUT
          http.put(env[:url].path, query.query, env[:headers])
        when :DELETE
          http.delete(env[:url].path, env[:headers])
        end

        [response.code.to_i, response, response.body]
      end
    end
  end
end
