require 'spec_helper'

describe Apis::Connection do
  let(:connection) do
    Apis::Connection.new(:uri => 'http://api.example.com/') do
      use EnvCheck
    end
  end

  context "on request" do
    [:head, :get, :post, :put, :delete].each do |method|
      it "sets env[:method] to :#{method.to_s.upcase} on #{method}" do
        connection.send(method)
        EnvCheck.env[:method].should == method.to_s.upcase.to_sym
      end
    end

    it "sets env[:uri] to Addressable::URI object initialized with URL" do
      connection.get
      EnvCheck.env[:uri].should == Addressable::URI.parse('http://api.example.com/')
    end

    it "merges uri passed to connection with uri passed to request" do
      connection.get('users/1')
      EnvCheck.env[:uri].should == Addressable::URI.parse('http://api.example.com/users/1')
    end

    it "sets env[:params] to params hash passed to request" do
      connection.get(nil, :param => 'test')
      EnvCheck.env[:params].should == {:param => 'test'}
    end

    it "sets env[:params] to params passed in block" do
      connection.get do |request|
        request.params[:param] = 'test'
      end
      EnvCheck.env[:params].should == {:param => 'test'}
    end

    it "sets env[:headers] to headers hash passed to request" do
      connection.get(nil, {}, {'Content-Type' => 'text/xml'})
      EnvCheck.env[:headers].should == {'Content-Type' => 'text/xml'}
    end

    it "sets env[:headers] to headers passed in block" do
      connection.get do |request|
        request.headers['Content-Type'] = 'text/xml'
      end
      EnvCheck.env[:headers].should == {'Content-Type' => 'text/xml'}
    end
  end
end
