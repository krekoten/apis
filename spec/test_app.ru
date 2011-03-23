require 'sinatra'

[:get, :post, :put, :delete, :head].each do |method|
  send(method, '/') do
    "#{method.to_s.upcase}" unless method == :head
  end
end

run Sinatra::Application
