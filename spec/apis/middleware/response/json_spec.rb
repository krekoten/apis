require 'spec_helper'

describe Apis::Middleware::Response::Json do
  it 'replaces body with parsed data' do
    MultiJson.engine = :yajl
    json = Apis::Middleware::Response::Json.new
    request = Apis::Response.new(200, {}, %|{"name":"Marjan Krekoten'","age": 23}|)
    json.call(request)
    request.body.should == {"name" => "Marjan Krekoten'", "age" => 23}
  end
end