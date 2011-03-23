module Apis
  class Builder
    def initialize
      @stack = []
      @mapping = {}
      if block_given?
        block = Proc.new
        block_eval(&block)
      end
    end

    def use(middleware)
      insert(middleware)
    end

    def replace(old, middleware)
      if index = @mapping[old]
        insert(middleware, index)
        remove(old)
      end
    end

    def insert(middleware, index = nil)
      raise Apis::DuplicateMiddleware, "#{middleware} already in stack" if include?(middleware)
      index ||= @stack.length
      @stack[index] = lambda do |parent|
        middleware.new(parent)
      end
      @mapping[middleware] = index
    end

    def remove(middleware)
      @stack.delete_at(@mapping.delete(middleware))
    end

    def length
      @stack.length
    end

    def include?(middleware)
      !!@mapping[middleware]
    end

    def to_a
      @mapping.to_a.sort { |a, b| a.last <=> b.last}.map { |e| e.first }
    end

    def to_app
      unless @stack.empty?
        inner_app = @stack.last.call(nil)
        @stack.reverse.inject(inner_app) { |parent, lazy| lazy.call(parent) }
      else
        []
      end
    end

    def block_eval(&block)
      instance_eval(&block)
    end
  end
end
