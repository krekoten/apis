module Apis
  class ConnectionScope
    def initialize
      @data = {}
    end

    def method_missing(method, value = nil)
      if method =~ /\=$/ && value
        @data[method.to_s.gsub(/\=/, '').to_sym] = value
      else
        @data[method]
      end
    end

    def scoped
      backup = {}
      @data.each do |key, value|
        backup[key] = value.dup
      end
      yield
    ensure
      backup.each do |key, value|
        @data[key] = value
      end
    end
  end
end
