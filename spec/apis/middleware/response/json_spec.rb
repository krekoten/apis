require 'spec_helper'

describe Apis::Middleware::Response::Json do
  it "calls decorated application" do
    middleware = double('middleware')
    middleware.should_receive(:call).and_return([200, {}, ''])
    Apis::Middleware::Response::Json.new(middleware).call({:headers => {}})
  end

  it "adds accept header" do
    middleware = -> env do
      env[:headers]['Accept'].should == 'application/json'
      [200, {'Content-Type' => 'application/json'}, %|{"user":{"name":"User","age":25}}|]
    end
    Apis::Middleware::Response::Json.new(middleware).call({:headers => {}})
  end

  it 'parses body when content-type matches' do
    middleware = -> env do
      [200, {'Content-Type' => 'application/json'}, %|{"user":{"name":"User","age":25}}|]
    end
    status, headers, body = Apis::Middleware::Response::Json.new(middleware).call(:headers => {})
    status.should == 200
    headers.should == {'Content-Type' => 'application/json'}
    body.should == {'user' => {'name' => 'User', 'age' => 25}}
  end
end
