require 'net/http'
require 'json'
require 'nokogiri'

module Linguine
  module Translator
    class Bing

      def initialize client_id, client_secret
        @last_authenticated_at = 0
        @client_id = client_id
        @client_secret = client_secret
      end

      def authenticate
        scope = 'http://api.microsofttranslator.com'
        grant_type = 'client_credentials'

        uri = URI('https://datamarket.accesscontrol.windows.net/v2/OAuth2-13')
        params = {
            client_id: @client_id,
            client_secret: @client_secret,
            scope: scope,
            grant_type: grant_type
        }
        res = Net::HTTP.post_form(uri, params)
        @last_authenticated_at = Time.now
        @authentication = JSON.parse(res.body)
      end

      def translate text, to, from = 'en'
        authenticate if authentication_expired?

        uri = URI('http://api.microsofttranslator.com/v2/Http.svc/Translate')
        params = {
          text: text,
          from: from,
          to: to
        }
        uri.query = URI.encode_www_form(params)

        res = Net::HTTP.start(uri.hostname, uri.port) do |http|
          req = Net::HTTP::Get.new(uri)
          req['Authorization'] = "Bearer #{@authentication['access_token']}"

          http.request(req)
        end
        doc = Nokogiri::XML(res.body)
        doc.css('string').first.content
      end

      def authentication_expired?
        return true unless @authentication
        (Time.now - @last_authenticated_at) >= @authentication.expires_in
      end
    end
  end
end