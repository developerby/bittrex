module Bittrex
  class Quote < BaseBittrex
    attr_reader :market, :bid, :ask, :last, :raw, :error

    def initialize(market, attrs = {})
      @market = market
      @bid = attrs['Bid']
      @ask = attrs['Ask']
      @last = attrs['Last']
      @error = attrs['message']
      @raw = attrs
    end

    # Example:
    # Bittrex::Quote.current('BTC-HPY')
    def self.current(market)
      response = client.get('public/getticker', market: market)
      return new(market, normalize_response(response)) if response.present?
    end
  end
end
