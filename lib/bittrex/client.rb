require 'rest-client'
require 'openssl'
require 'addressable/uri'
require 'base64'

module Bittrex
  class Client
    HOST = 'https://bittrex.com/api/v1.1'

    attr_reader :key, :secret

    def initialize(attrs = {})
      @key    = attrs[:key]
      @secret = attrs[:secret]
    end

    def get(path, params = {})
      encoded_params = encode_params(params)

      uri = "#{HOST}/#{path}?#{encoded_params}"
      response = resource(uri).get({ 'apisign' => signature(uri) })

      prepare_response(JSON.parse(response.body))
    end

    private

    def prepare_response(response)
      response['success'] ? response['result'] : [response]
    end

    def resource(uri)
      RestClient::Resource.new(uri)
    end

    def encode_params(params)
      Addressable::URI.form_encode(params.merge({ apikey: key,
        nonce: Time.now.to_i }))
    end

    def signature(uri)
      OpenSSL::HMAC.hexdigest('sha512', secret, uri)
    end
  end
end
