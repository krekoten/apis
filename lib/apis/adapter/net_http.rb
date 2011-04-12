require 'net/http'

module Apis
  module Adapter
    class NetHTTP
      def call(env)
        env[:uri].path = '/' if env[:uri].path.empty?
        http = Net::HTTP.new(env[:uri].host, env[:uri].port)
        query = Addressable::URI.new
        query.query_values = env[:params]
        response = case env[:method]
        when :GET
          http.get([env[:uri].path, query.query].compact.join('?'), env[:headers])
        when :HEAD
          http.head([env[:uri].path, query.query].compact.join('?'), env[:headers])
        when :POST
          http.post(env[:uri].path, query.query, env[:headers])
        when :PUT
          http.put(env[:uri].path, query.query, env[:headers])
        when :DELETE
          http.delete([env[:uri].path, query.query].compact.join('?'), env[:headers])
        end

        [response.code.to_i, response, response.body]
      end
    end
  end
end
