require 'spec_helper'

class RackApp
  def call(env)
    [
      200,
      {
        'X-Request-Method' => env['REQUEST_METHOD'],
        'X-Request-At' => env['PATH_INFO']
      },
      env['REQUEST_METHOD'] == 'HEAD' ? [] : [env['REQUEST_METHOD']]
    ]
  end
end

describe Apis::Adapter::RackTest do
end
