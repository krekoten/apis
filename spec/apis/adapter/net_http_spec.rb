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
      it "performs #{method}" do
        adapter = Apis::Adapter::NetHTTP.new(:uri => Addressable::URI.parse(server_host))
        headers, body = adapter.send(method, '/')
        body.should == method.to_s.upcase
      end unless method == :head
    end
  end
end
