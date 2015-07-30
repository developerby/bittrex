module Bittrex
  class Trade < BaseBittrex
    attr_reader :id, :raw, :error

    def initialize(attrs = {})
      @id = attrs['uuid']
      @error = attrs['message']
      @raw = attrs
    end

    def self.sell(market, rate, quantity)
      response = client.get('market/selllimit',
        market: market,
        quantity: quantity,
        rate: rate
      )
      prepare_response(response)
    end

    def self.buy(market, rate, quantity)
      response = client.get('market/buylimit',
        market: market,
        quantity: quantity,
        rate: rate
      )
      prepare_response(response)
    end

    private

    def self.prepare_response(response)
      response = normalize_response(response)
      new(response) if response.present?
    end
  end
end