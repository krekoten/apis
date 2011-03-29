require 'spec_helper'

describe Apis::Middleware::Response::Json do
  it 'replaces body with parsed data' do
    MultiJson.engine = :yajl
    json = Apis::Middleware::Response::Json.new
    request = Apis::Response.new(200, {}, %|{"name":"Marjan Krekoten'","age": 23}|)
    json.call(request)
    request.body.should == {"name" => "Marjan Krekoten'", "age" => 23}
  end

  it 'registered under :json' do
    Apis::Connection.new do
      response do
        use :json
      end
    end.response.to_a.should include(Apis::Middleware::Response::Json)
  end
end