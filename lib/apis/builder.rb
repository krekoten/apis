module Apis
  class Builder
    attr_accessor :lookup_context
    def initialize(options = {}, &block)
      options.each do |key, value|
        send("#{key}=", value) if respond_to?("#{key}=")
      end
      @stack = []
      @mapping = {}
      block_eval(&block) if block
    end

    def use(middleware)
      insert(middleware)
    end

    def replace(old, middleware)
      if index = index(old)
        insert(middleware, index)
        remove(old)
      end
    end

    def insert(middleware, index = nil)
      middleware = lookup_middleware(middleware)
      raise Apis::DuplicateMiddleware, "#{middleware} already in stack" if include?(middleware)
      index ||= @stack.length
      @stack[index] = lambda do |parent|
        middleware.new(parent)
      end
      @mapping[middleware] = index
    end

    def remove(middleware)
      middleware = lookup_middleware(middleware)
      @stack.delete_at(@mapping.delete(middleware))
    end

    def index(middleware)
      middleware = lookup_middleware(middleware)
      @mapping[middleware]
    end

    def length
      @stack.length
    end

    def include?(middleware)
      !!index(middleware)
    end

    def to_a
      @mapping.to_a.sort { |a, b| a.last <=> b.last}.map { |e| e.first }
    end
    alias to_ary to_s

    def to_app
      unless @stack.empty?
        inner_app = @stack.last.call(nil)
        @stack.reverse[1..-1].inject(inner_app) { |parent, lazy| lazy.call(parent) }
      else
        []
      end
    end

    def block_eval(&block)
      instance_eval(&block)
    end

    def lookup_middleware(middleware)
      @lookup_context && !(Class === middleware) ?
        @lookup_context.lookup(middleware) :
        middleware
    end
  end
end
