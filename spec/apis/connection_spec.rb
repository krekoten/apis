require 'spec_helper'

describe Apis::Connection do
  context 'configuration' do
    context 'options' do
      it 'sets url' do
        Apis::Connection.new(:uri => 'http://api.example.org').uri.should == Addressable::URI.parse('http://api.example.org')
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
        connection.uri = 'http://api.example.org'
        connection.uri.should == Addressable::URI.parse('http://api.example.org')
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
          adapter FakeAdapter
        end
        connection.adapter.should be_instance_of(FakeAdapter)
      end

      it 'finds adapter using symbol shortcut' do
        Apis::Adapter.register(:fake, FakeAdapter)
        connection = Apis::Connection.new do
          adapter :fake
        end
        connection.adapter.should be_instance_of(FakeAdapter)
      end

      it 'uses default adapter if none specified' do
        Apis::Connection.new.adapter.should_not be_nil
      end
    end
  end

  context 'performing request' do
    before do
      @connection = Apis::Connection.new(:uri => server_host) do
        adapter FakeAdapter
      end
    end

    [:get, :head, :post, :put, :delete].each do |method|
      context method.to_s.upcase do
        it 'passes method to adapter' do
          @connection.send(method)
          @connection.adapter.last_method.should == method
        end

        it 'passes path to adapter' do
          @connection.send(method, "/#{method}")
          @connection.adapter.last_path.should == "/#{method}"
        end

        it 'passes query params to adapter' do
          @connection.send(method, "/#{method}", {:q => 'text'})
          @connection.adapter.last_params.should == {:q => 'text'}
        end

        it 'passes params specified in block' do
          @connection.send(method, "/#{method}") do |request|
            request.params = {:test => 'params'}
          end
          @connection.adapter.last_params.should == {:test => 'params'}
        end

        it 'doesn\'t not overwrite params of connection' do
          @connection.params = {:q => 'test'}
          @connection.send(method, "/#{method}") do |request|
            request.params = {:test => 'params'}
          end
          @connection.adapter.last_params.should == {:q => 'test', :test => 'params'}
          @connection.params.should == {:q => 'test'}
        end

        it 'merges connection params with method params' do
          @connection.params = {:test => 'param'}
          @connection.send(method, "/#{method}", {:q => 'text'})
          @connection.adapter.last_params.should == {:q => 'text', :test => 'param'}
        end

        it 'passes headers to adapter' do
          @connection.send(method, "/#{method}", {}, {'Content-Type' => 'text'})
          @connection.adapter.last_headers.should == {'Content-Type' => 'text'}
        end

        it 'merges connection headers with method headers' do
          @connection.headers = {'User-Agent' => 'apis'}
          @connection.send(method, "/#{method}", {}, {'Content-Type' => 'text'})
          @connection.adapter.last_headers.should == {'Content-Type' => 'text', 'User-Agent' => 'apis'}
        end

        it 'doesn\'t not overwrite headers of connection' do
          @connection.headers = {:q => 'test'}
          @connection.send(method, "/#{method}") do |request|
            request.headers = {:test => 'params'}
          end
          @connection.adapter.last_headers.should == {:q => 'test', :test => 'params'}
          @connection.headers.should == {:q => 'test'}
        end
      end
    end
  end
end
