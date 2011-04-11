require 'fiber'

module Apis
  class Request
    attr_accessor :params, :headers
    def initialize
      @params, @headers = {}, {}
    end
  end

  class Connection
    attr_reader :uri
    def initialize(options)
      options.each do |key, value|
        send("#{key}=", value) if respond_to?("#{key}=")
      end
      @builder = Builder.new(&(block_given? ? Proc.new : nil))
    end

    def uri=(value)
      @uri = Addressable::URI.parse(value)
    end

    def head(*args, &block)   make_request(:HEAD, *args, &block) end

    def get(*args, &block)    make_request(:GET, *args, &block) end

    def post(*args, &block)   make_request(:POST, *args, &block) end

    def put(*args, &block)    make_request(:PUT, *args, &block) end

    def delete(*args, &block) make_request(:DELETE, *args, &block) end

    def make_request(method, uri = nil, params = {}, headers = {}, &block)
      if block
        request = Apis::Request.new
        yield request
        params.merge!(request.params)
        headers.merge!(request.headers)
      end

      Fiber.new do
        @builder.to_app.call(
          :method   => method,
          :uri      => uri ? self.uri.join(uri) : self.uri,
          :params   => params,
          :headers  => headers
        )
      end.resume
    end
  end
end
