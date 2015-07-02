require_relative './TestRackApp.rb'
require_relative './app.rb'
require_relative 'lib/translator/bing'
require_relative 'lib/translator/google'

if ENV['RACK_ENV'] == 'production'
  client_id = ENV['LINGUINE_BING_CLIENT_ID']
  client_secret = ENV['LINGUINE_BING_CLIENT_SECRET']
  if !client_id || !client_secret
    raise ArgumentError, 'Missing Bing Client Id or Client Secret'
  end
  translator = Linguine::Translator::Bing.new client_id, client_secret
else
  translator = Linguine::Translator::Google.new
end

use LinguineRackApp, translator
run TestRackApp.new