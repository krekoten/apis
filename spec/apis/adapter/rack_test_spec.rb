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
      let(:adapter) { Apis::Adapter::RackTest.new(:app => RackApp.new) }
      it "returns body" do
        status, headers, body = adapter.run(method, '/')
        body.should == method.to_s.upcase
      end unless method == :head

      it "returns headers" do
        status, headers, body = adapter.run(method, '/')
        headers['X-Request-Method'].should == method.to_s.upcase
      end

      it "returns status" do
        status, headers, body = adapter.run(method, '/')
        status.should == 200
      end

      it 'saves passed path' do
        adapter.run(method, "/#{method}")
        adapter.last_path.should == "/#{method}"
      end

      it 'saves passed params' do
        adapter.run(method, '/', {:test => 'param'})
        adapter.last_params.should == {:test => 'param'}
      end

      it 'saves passed headers' do
        adapter.run(method, '/', {}, {'Content-Type' => 'text'})
        adapter.last_headers.should == {'Content-Type' => 'text'}
      end
    end
  end
end
