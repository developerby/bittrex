module Bittrex
  class Market < BaseBittrex
    attr_reader :name, :currency, :base, :currency_name, :base_name, :minimum_trade, :active, :created_at, :raw, :error

    def initialize(attrs = {})
      @name = attrs['MarketName']
      @currency = attrs['MarketCurrency']
      @base = attrs['BaseCurrency']
      @currency_name = attrs['MarketCurrencyLong']
      @base_name = attrs['BaseCurrencyLong']
      @minimum_trade = attrs['MinTradeSize']
      @active = attrs['IsActive']
      @created_at = Time.parse(attrs['Created'])
      @error = attrs['message']
      @raw = attrs
    end

    def self.all
      client.get('public/getmarkets').map{|data| new(data) }
    end
  end
end
