require 'spec_helper'

describe Apis::Builder do
  it 'builds appilcation stack' do
    app = Apis::Builder.new do
      use NewMiddleware
      use RESTMiddleware
      adapter FakeAdapter
    end.to_app
    app.should be_instance_of(NewMiddleware)
    app.app.should be_instance_of(RESTMiddleware)
    app.app.app.should be_instance_of(FakeAdapter)
  end

  it 'uses default adapter if none specified' do
    app = Apis::Builder.new do
      use NewMiddleware
      use RESTMiddleware
    end.to_app
    app.should be_instance_of(NewMiddleware)
    app.app.should be_instance_of(RESTMiddleware)
    app.app.app.should be_instance_of(Apis::Adapter::NetHTTP)
  end
end
