require 'spec_helper'

describe Apis::Builder do
  it 'adds middleware to stack' do
    builder = Apis::Builder.new
    builder.use Middleware
    builder.length.should == 1
  end

  it 'raises error when duplicate middleware added' do
    builder = Apis::Builder.new
    builder.use Middleware
    expect { builder.use Middleware }.to raise_error(Apis::DuplicateMiddleware, 'Middleware already in stack')
  end

  it 'shows if middleware in stack' do
    builder = Apis::Builder.new
    builder.use Middleware
    builder.include?(Middleware).should == true
  end

  it 'replaces middleware with another' do
    builder = Apis::Builder.new
    builder.use Middleware
    builder.use RESTMiddleware
    builder.replace Middleware, NewMiddleware
    builder.include?(Middleware).should == false
    builder.include?(NewMiddleware).should == true
    builder.to_a.should == [NewMiddleware, RESTMiddleware]
  end

  it 'removes middleware from stack' do
    builder = Apis::Builder.new
    builder.use Middleware
    builder.include?(Middleware).should == true
    builder.remove(Middleware)
    builder.include?(Middleware).should == false
  end

  it 'returns stacked middlewares in order' do
    builder = Apis::Builder.new
    builder.use Middleware
    builder.use NewMiddleware
    builder.use RESTMiddleware
    app = builder.to_app
    app.should be_instance_of(Middleware)
    app.app.should be_instance_of(NewMiddleware)
    app.app.app.should be_instance_of(RESTMiddleware)
  end

  it 'evals block' do
    builder = Apis::Builder.new
    builder.block_eval do |builder|
      use Middleware
      use NewMiddleware
      use RESTMiddleware
    end

    app = builder.to_app
    app.should be_instance_of(Middleware)
    app.app.should be_instance_of(NewMiddleware)
    app.app.app.should be_instance_of(RESTMiddleware)
  end

  it 'evals block passed to constructor' do
    builder = Apis::Builder.new do
      use Middleware
      use NewMiddleware
      use RESTMiddleware
    end

    app = builder.to_app
    app.should be_instance_of(Middleware)
    app.app.should be_instance_of(NewMiddleware)
    app.app.app.should be_instance_of(RESTMiddleware)
  end
end
