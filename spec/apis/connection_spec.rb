require 'spec_helper'

class EnvCheck
  class << self
    attr_accessor :env
    def call(env)
      @env = env
    end
    def new(*args)
      self
    end
  end
end
    

describe Apis::Connection do
  context "on request" do
    [:head, :get, :post, :put, :delete].each do |method|
      it "sets env[:method] to :#{method.to_s.upcase} on #{method}" do
        Apis::Connection.new(:url => 'http://api.example.com/') do
          use EnvCheck
        end.send(method)
        EnvCheck.env[:method].should == method.to_s.upcase.to_sym
      end
    end

    it "sets env[:uri] to Addressable::URI object initialized with URL" do
      Apis::Connection.new(:uri => 'http://api.example.com/') do
        use EnvCheck
      end.get
      EnvCheck.env[:uri].should == Addressable::URI.parse('http://api.example.com/')
    end

    it "merges uri passed to connection with uri passed to request" do
      Apis::Connection.new(:uri => 'http://api.example.com/') do
        use EnvCheck
      end.get('users/1')
      EnvCheck.env[:uri].should == Addressable::URI.parse('http://api.example.com/users/1')
    end

    it "sets env[:params] to params hash passed to request" do
      Apis::Connection.new(:uri => 'http://api.example.com/') do
        use EnvCheck
      end.get(nil, :param => 'test')
      EnvCheck.env[:params].should == {:param => 'test'}
    end
  end
end
