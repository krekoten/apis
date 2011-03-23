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

      [:get, :post, :put, :delete, :head].each do |method|
        class_eval <<-CODE, __FILE__, __LINE__ + 1
          def #{method}(path)
            block = block_given? ? Proc.new : nil
            perform_request(#{method.inspect}, path, &block)
          end
        CODE
      end

      # Performs request to resource
      def perform_request(method, path)
        _module = Net::HTTP.const_get(method.to_s.capitalize)
        request = _module.new(path)
        response = Net::HTTP.start(uri.host, uri.port) do |http|
          http.request(request)
        end
      end
    end
  end
end
