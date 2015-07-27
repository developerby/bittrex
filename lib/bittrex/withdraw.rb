module Bittrex
  class Withdraw
    attr_reader :id, :raw

    def initialize(attrs = {})
      @id = attrs['uuid']
      @raw = attrs
    end

    def self.send(currency, quantity, address)
      response = client.get('account/withdraw', currency: currency, quantity: quantity, address: address)
      return new(response) if response.present?
    end

    private

    def self.client
      @client ||= Bittrex.client
    end

  end
end