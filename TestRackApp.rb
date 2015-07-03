require 'rack/response'

class TestRackApp
  def call env
    response = Rack::Response.new
    response.write '<html><body><h1>Hello World</h1><p>This is a test string</p></body></html>'
    response['Content-Type'] = 'text/html'
    response.status = 200

    response.finish
  end
end