module Apis
  class Connection
    def initialize(oprions = {})
      @scope = Apis::ConnectionScope.new
      @scope.headers, @scope.params = {}, {}
      oprions.each do |key, value|
        send("#{key}=", value) if respond_to?("#{key}=")
      end
      if block_given?
        block = Proc.new
        instance_eval(&block)
      end
      adapter(Apis::Adapter.default) unless @adapter
    end

    def uri
      @scope.uri
    end

    def uri=(value)
      @scope.uri = Addressable::URI.parse(value)
    end

    def headers
      @scope.headers
    end

    def headers=(value)
      @scope.headers.merge!(value)
    end

    def params
      @scope.params
    end

    def params=(value)
      @scope.params.merge!(value)
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
        value = Apis::Adapter.lookup(value)
      end

      @adapter = value.new(:uri => uri) if value
      @adapter
    end

    [:get, :head, :post, :put, :delete].each do |method|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{method}(path = nil, params = {}, headers = {})
          run_request(#{method.inspect}, path, params, headers, &(block_given? ? Proc.new : nil))
        end
      RUBY
    end

    def run_request(method, path = nil, params = {}, headers = {}, &block)
      #block = block_given? ? Proc.new : nil
      # TODO: refactor this, it's ugly
      @scope.scoped do
        self.params = params if params
        self.headers = headers if headers
        block.call(self) if block
        path ||= uri.path.empty? ? '/' : uri.path
        self.request.to_app.call(
          :method => method,
          :params => self.params,
          :headers => self.headers
        ) unless self.request.to_a.empty?
        res = Apis::Response.new(*adapter.run(method, path, self.params, self.headers))
        self.response.to_app.call(res) unless self.response.to_a.empty?
        res
      end
    end
  end
end
