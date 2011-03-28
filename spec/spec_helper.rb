require File.expand_path('../../lib/apis', __FILE__)

class BaseMiddleware
  attr_accessor :app
  def initialize(app)
    @app = app
  end
end
Middleware = Class.new(BaseMiddleware)
NewMiddleware = Class.new(BaseMiddleware)
RESTMiddleware = Class.new(BaseMiddleware)

class FakeAdapter < Apis::Adapter::Abstract
  attr_accessor :last_method, :last_path, :last_params, :last_headers
  def run(method, path = nil, params = {}, headers = {})
    @last_method, @last_path, @last_params, @last_headers = method, path, params, headers
  end
end

module DirHelper
  def root
    @root ||= File.expand_path('../..', __FILE__)
  end
end

module SinatraHelper
  def server_port
    1234
  end

  def server_host
    "http://localhost:#{server_port}"
  end

  def start_server
    %x{unicorn -p #{server_port} #{root}/spec/test_app.ru -D -P #{root}/spec/uni.pid} # 3&> /dev/null
  end

  def stop_server
    %x{kill `cat #{root}/spec/uni.pid`}
  end
end

RSpec.configure do |rspec|
  rspec.include DirHelper
  rspec.include SinatraHelper
end
