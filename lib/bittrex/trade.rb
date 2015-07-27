module Bittrex
  class Trade
    attr_reader :id, :raw

    def initialize(attrs = {})
      @id = attrs['uuid']
      @raw = attrs
    end

    def self.sell(market, quantity, rate)
      response = client.get('market/selllimit',
        market: market,
        quantity: quantity,
        rate: rate
      )
      new(response) if response.present?
    end

    def self.buy(market, quantity, rate)
      response = client.get('market/buylimit',
        market: market,
        quantity: quantity,
        rate: rate
      )
      new(response) if response.present?
    end

    private

    def self.client
      @client ||= Bittrex.client
    end
  end
end