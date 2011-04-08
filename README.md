## Usage

    connection = Apis::Connecton.new(:url => 'http://api.example.com') do
      use Apis::Request::JSON
      use Apis::Request::OAuth2
      use Apis::Request::Logger
      adapter Apis::Adapter::NetHTTP
    end
		
    connection.get('/hello')

## Specification

### Middleware

Middleware is object that responds to `call`, accepts `env` hash and returns array
with three elements in order: `status`, `headers`, `body`.

Middleware should accept `application` it decorates as first parameter to initializer.

Example middleware:

    class Middleware
      def initialize(app)
        @app = app
      end
      
      def call(env)
        # do something with request
        response = @app.call(env) # it's decorator, you are responsible to forward message to decorated app
        # do something with response
        response
      end
    end

### Environment

* `:method` - uppercased request method, should be one of: `:GET`, `:POST`, `:PUT`, `:DELETE`
* `:uri` - parsed URi, instance of `Addressable::URI`
* `:params` - params to be sent, instance of `Hash`
* `:body` - body to be sent. If set than `:params` are not used
* `:headers` - headers to be sent, instance of `Hash`