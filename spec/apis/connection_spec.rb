require 'spec_helper'

describe Apis::Connection do
  context 'configuration' do
    context 'options' do
      it 'sets url' do
        Apis::Connection.new(:url => 'http://api.example.org').url.should == 'http://api.example.org'
      end

      it 'sets headers' do
        Apis::Connection.new(
          :headers => {
            'Content-Type' => 'text',
            'User-Agent' => 'apis'
          }
        ).headers.should == {
          'Content-Type' => 'text',
          'User-Agent' => 'apis'
        }
      end

      it 'sets params' do
        Apis::Connection.new(
          :params => {:q => 'apis', :hl => 'uk'}
        ).params.should == {:q => 'apis', :hl => 'uk'}
      end
    end

    context 'methods' do
      let(:connection) { Apis::Connection.new }
      it 'sets url' do
        connection.url = 'http://api.example.org'
        connection.url.should == 'http://api.example.org'
      end

      it 'sets headers' do
        connection.headers = {
          'Content-Type' => 'text',
          'User-Agent' => 'apis'
        }
        connection.headers.should == {
          'Content-Type' => 'text',
          'User-Agent' => 'apis'
        }
      end

      it 'sets params' do
        connection.params = {:q => 'apis', :hl => 'uk'}
        connection.params.should == {:q => 'apis', :hl => 'uk'}
      end

      it 'updates headers' do
        connection.headers = {'Content-Type' => 'text'}
        connection.headers = {'User-Agent' => 'apis'}
        connection.headers.should == {
          'Content-Type' => 'text',
          'User-Agent' => 'apis'
        }
      end

      it 'updates params' do
        connection.params = {:q => 'apis'}
        connection.params = {:hl => 'uk'}
        connection.params.should == {:q => 'apis', :hl => 'uk'}
      end
    end

    context 'stack building' do
      it 'constructs request stack' do
        connection = Apis::Connection.new do
          request do
            use Middleware
            use NewMiddleware
            use RESTMiddleware
          end
        end

        connection.request.to_a.should == [Middleware, NewMiddleware, RESTMiddleware]
      end

      it 'constructs response stack' do
        connection = Apis::Connection.new do
          response do
            use Middleware
            use NewMiddleware
            use RESTMiddleware
          end
        end

        connection.response.to_a.should == [Middleware, NewMiddleware, RESTMiddleware]
      end

      it 'sets adapter' do
        connection = Apis::Connection.new do
          adapter Apis::Adapter::NetHTTP.new
        end
        connection.adapter.should be_instance_of(Apis::Adapter::NetHTTP)
      end
    end
  end
end
