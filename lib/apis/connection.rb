module Apis
  class Connection
    attr_accessor :url
    attr_reader :headers, :params

    def initialize(oprions = {})
      @headers, @params = {}, {}
      oprions.each do |key, value|
        send("#{key}=", value) if respond_to?("#{key}=")
      end
      if block_given?
        block = Proc.new
        instance_eval(&block)
      end
    end

    def headers=(value)
      @headers.merge!(value)
    end

    def params=(value)
      @params.merge!(value)
    end

    def request
      if block_given?
        block = Proc.new
        @request = Apis::Builder.new(&block)
      end
      @request
    end

    def response
      if block_given?
        block = Proc.new
        @response = Apis::Builder.new(&block)
      end
      @response
    end

    def adapter(value = nil)
      @adapter = value if value
      @adapter
    end
  end
end
