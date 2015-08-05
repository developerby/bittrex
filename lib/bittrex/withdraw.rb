module Bittrex
  class Withdraw < BaseBittrex
    attr_reader :id, :raw, :error, :success

    def initialize(attrs = {})
      @id = attrs['uuid']
      @error = attrs['message']
      @success = @error.nil?
      @raw = attrs
    end

    def self.send(currency, quantity, address)
      response = client.get('account/withdraw', currency: currency, quantity: quantity, address: address)
      return new(normalize_response(response)) if response.present?
    end
  end
end