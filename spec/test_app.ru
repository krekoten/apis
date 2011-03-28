require 'sinatra'

[:head, :get, :post, :put, :delete].each do |method|
  send(method, '/') do
    headers['X-Requested-With-Method'] = method.to_s.upcase
    "#{method.to_s.upcase}" unless method == :head
  end

  send(method, "/#{method}") do
    headers['X-Requested-With-Method'] = method.to_s.upcase
    headers['X-Sent-Params'] = params.inspect
    "#{method.to_s.upcase}" unless method == :head
  end
end

run Sinatra::Application
