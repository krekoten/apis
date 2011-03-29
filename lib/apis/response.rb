module Apis
  class Response
    attr_accessor :status, :headers, :body
    def initialize(status, headers, body)
      @status, @headers, @body = status, headers, body
    end

    def to_env
      {:status => status, :headers => headers, :body => body}
    end

    def to_a
      [status, headers, body]
    end
    alias to_ary to_a

    def [](key)
      respond_to?(key) ? send(key) : nil
    end

    def []=(key, value)
      send("#{key}=", value) if respond_to?("#{key}=")
    end
  end
end
