module Apis
  class Builder
    def initialize(&block)
      @handlers = []
      @adapter = nil
      instance_eval(&block) if block
    end

    def use(middleware, *args)
      block = block_given? ? Proc.new : nil
      @handlers << -> parent do
        middleware.new(parent, *args, &block)
      end
    end

    def adapter(middleware = nil, *args)
      if middleware
        block = block_given? ? Proc.new : nil
        @adapter = nil
      end
      @adapter ||= -> do
        (middleware || Apis::Adapter::NetHTTP).new(*args, &block)
      end
    end

    def to_app
      @handlers.reverse.inject(adapter.call) do |parent, handler|
        handler.call(parent)
      end
    end
  end
end
