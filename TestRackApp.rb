require 'rack/response'

class TestRackApp
  def call env
    ["200", {"Content-Type" => "text/plain"}, ["This is a test string"]]
  end
end