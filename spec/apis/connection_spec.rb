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
          adapter FakeAdapter.new
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
    before(:all) do
      start_server
    end

    after(:all) do
      stop_server
    end

    context 'simple' do
      [:get, :head, :post, :put, :delete].each do |method|
        context method.to_s.upcase do
          it 'returns body' do
            connection = Apis::Connection.new(:uri => server_host)
            status, headers, body = connection.send(method)
            body.should == method.to_s.upcase
          end unless method == :head

          it 'returns headers' do
            connection = Apis::Connection.new(:uri => server_host)
            status, headers, body = connection.send(method)
            headers['X-Requested-With-Method'].should == method.to_s.upcase
          end

          it 'returns headers' do
            connection = Apis::Connection.new(:uri => server_host)
            status, headers, body = connection.send(method)
            status.should == 200
          end
        end
      end
    end
  end
end
