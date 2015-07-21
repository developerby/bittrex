module Bittrex
  class Quote
    attr_reader :market, :bid, :ask, :last, :raw

    def initialize(market, attrs = {})
      @market = market
      @bid = attrs['Bid']
      @ask = attrs['Ask']
      @last = attrs['Last']
      @raw = attrs
    end

    # Example:
    # Bittrex::Quote.current('BTC-HPY')
    def self.current(market)
      response = client.get('public/getticker', market: market)
      return new(market, response) if response.present?
    end

    private

    def self.client
      @client ||= Bittrex.client
    end
  end
end
