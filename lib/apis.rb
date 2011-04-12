$: << lib_dir unless $:.include?(lib_dir = File.expand_path('..', __FILE__))

require 'addressable/uri'

module Apis

  autoload :Connection,       'apis/connection'
  autoload :Builder,          'apis/builder'

  module Adapter
    autoload :Abstract,         'apis/adapter/abstract'
    autoload :NetHTTP,          'apis/adapter/net_http'
    autoload :RackTest,         'apis/adapter/rack_test'
  end

  module Middleware
    module Response
      autoload :Json,             'apis/middleware/response/json'
    end
  end
end
