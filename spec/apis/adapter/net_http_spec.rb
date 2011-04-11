require 'spec_helper'
require 'addressable/uri'

describe Apis::Adapter::NetHTTP do
  before(:all) do
    start_server
  end
  after(:all) do
    stop_server
  end

  [:HEAD, :GET, :POST, :PUT, :DELETE].each do |method|
    context method do
      it "returns status" do
        adapter = Apis::Adapter::NetHTTP.new
        status, headers, body = adapter.call(
          :method   => method,
          :url      => Addressable::URI.parse(server_host),
          :headers  => {}
        )
        status.should == 200
      end

      it "returns body" do
        adapter = Apis::Adapter::NetHTTP.new
        status, headers, body = adapter.call(
          :method   => method,
          :url      => Addressable::URI.parse(server_host),
          :headers  => {}
        )
        body.should == method.to_s
      end unless method == :HEAD

      it "returns headers" do
        adapter = Apis::Adapter::NetHTTP.new
        status, headers, body = adapter.call(
          :method   => method,
          :url      => Addressable::URI.parse(server_host),
          :headers  => {}
        )
        headers['X-Requested-With-Method'].should == method.to_s
      end

      it "sends params" do
        adapter = Apis::Adapter::NetHTTP.new
        status, headers, body = adapter.call(
          :method   => method,
          :url      => Addressable::URI.parse(server_host).join(method.to_s.downcase),
          :headers  => {},
          :params   => {:test => 'params'}
        )
        headers['X-Sent-Params'].should == %|{"test"=>"params"}|
      end
    end
  end
end
