require 'spec_helper'
require 'addressable/uri'

describe Apis::Adapter::NetHTTP do
  before(:all) do
    start_server
  end
  after(:all) do
    stop_server
  end

  [:get, :post, :put, :delete, :head].each do |method|
    context method.to_s.upcase do
      it "returns body" do
        adapter = Apis::Adapter::NetHTTP.new(:uri => Addressable::URI.parse(server_host))
        status, headers, body = adapter.run(method, '/')
        body.should == method.to_s.upcase
      end unless method == :head

      it "returns headers" do
        adapter = Apis::Adapter::NetHTTP.new(:uri => Addressable::URI.parse(server_host))
        status, headers, body = adapter.run(method, '/')
        headers['X-Requested-With-Method'].should == method.to_s.upcase
      end

      it "returns status" do
        adapter = Apis::Adapter::NetHTTP.new(:uri => Addressable::URI.parse(server_host))
        status, headers, body = adapter.run(method, '/')
        status.should == 200
      end

      it "sends params" do
        adapter = Apis::Adapter::NetHTTP.new(:uri => Addressable::URI.parse(server_host))
        status, headers, body = adapter.run(method, "/#{method}", {:param => 'value'})
        headers['X-Sent-Params'].should == '{"param"=>"value"}'
      end
    end
  end

  it 'registers itself under :net_http' do
    Apis::Connection.new do
      adapter :net_http
    end.adapter.should be_instance_of(Apis::Adapter::NetHTTP)
  end
end
