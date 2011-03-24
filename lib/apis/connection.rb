module Apis
  class Connection
    attr_reader :headers, :params, :uri

    def initialize(oprions = {})
      @headers, @params = {}, {}
      oprions.each do |key, value|
        send("#{key}=", value) if respond_to?("#{key}=")
      end
      if block_given?
        block = Proc.new
        instance_eval(&block)
      end
      adapter(Apis::Adapter.default) unless @adapter
    end

    def uri=(value)
      @uri = Addressable::URI.parse(value)
    end

    def headers=(value)
      @headers.merge!(value)
    end

    def params=(value)
      @params.merge!(value)
    end

    def request
      block = block_given? ? Proc.new : nil
      @request ||= Apis::Builder.new(&block)
      @request
    end

    def response
      block = block_given? ? Proc.new : nil
      @response ||= Apis::Builder.new(&block)
      @response
    end

    def adapter(value = nil)
      if Symbol === value
        value = Apis::Adapter.get_instance(value)
      end
      if value
        @adapter = value
        @adapter.uri = uri
      end
      @adapter
    end

    [:get, :head, :post, :put, :delete].each do |method|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{method}(path = nil)
          block = block_given? ? Proc.new : nil
          path ||= uri.path.empty? ? '/' : uri.path
          adapter.run(#{method.inspect}, path, block)
        end
      RUBY
    end
  end
end
