require 'rack/test'

module Apis
  module Adapter
    class RackTest < Abstract
      include Rack::Test::Methods
      attr_accessor :app
    end
  end
end
