require 'spec_helper'

class RackApp
  def call(env)
    [
      200,
      {
        'X-Request-Method' => env['REQUEST_METHOD'],
        'X-Request-At' => env['PATH_INFO']
      },
      env['REQUEST_METHOD'] == 'HEAD' ? [] : [env['REQUEST_METHOD']]
    ]
  end
end

describe Apis::Adapter::RackTest do
  [:get, :post, :put, :delete, :head].each do |method|
    context method.to_s.upcase do
      it "returns body" do
        adapter = Apis::Adapter::RackTest.new(:app => RackApp.new)
        status, headers, body = adapter.run(method, '/')
        body.should == method.to_s.upcase
      end unless method == :head

      it "returns headers" do
        adapter = Apis::Adapter::RackTest.new(:app => RackApp.new)
        status, headers, body = adapter.run(method, '/')
        headers['X-Request-Method'].should == method.to_s.upcase
      end

      it "returns status" do
        adapter = Apis::Adapter::RackTest.new(:app => RackApp.new)
        status, headers, body = adapter.run(method, '/')
        status.should == 200
      end
    end
  end
end
