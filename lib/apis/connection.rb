module Apis
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

    def head(*args)   make_request(:HEAD, *args) end

    def get(*args)    make_request(:GET, *args) end

    def post(*args)   make_request(:POST, *args) end

    def put(*args)    make_request(:PUT, *args) end

    def delete(*args) make_request(:DELETE, *args) end

    def make_request(method, uri = nil, params = {})
      @builder.to_app.call(
        :method => method,
        :uri => uri ? self.uri.join(uri) : self.uri,
        :params => params
      )
    end
  end
end
