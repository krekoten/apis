module Apis
  module Adapter
    class Abstract
      class NotImplemented < StandardError; end

      attr_accessor :uri

      def initialize(options = {})
        options.each do |key, value|
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

      # Performs request to resource
      #
      # @param [Symbol, String] method HTTP method to perform
      # @param [String] path Relative path to resource host
      # @param [Hash] params Params to be sent
      # @param [Hash] headers Headers to be sent
      #
      # @return [Array] headers, body
      def run(method, path, params = {}, headers = {})
        raise Apis::Adapter::Abstract::NotImplemented
      end
    end
  end
end
