## Usage

		connection = Apis::Connecton.new(:url => 'http://api.example.com') do
			request do
				use Apis::Request::JSON			# |
				use Apis::Request::OAuth2		# |
				use Apis::Request::Logger		# \/
			end
			adapter :net_http					# -->
			response do
				use Apis::Response::JSON		# |
				use Apis::Response::Logger		# \/
			end
		end
		
		connection.get('/hello')
		
		connection.request.replace Apis::Request::OAuth2, Apis::Request::OAuth
		
		connection.post('/post_with_oauth_10') do |request|
			request.params = {:q => 'm'}
		end