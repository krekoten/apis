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

module DirHelper
  def root
    @root ||= File.expand_path('../..', __FILE__)
  end
end

module SinatraHelper
end

RSpec.configure do |rspec|
  rspec.include DirHelper
  rspec.include SinatraHelper
end
