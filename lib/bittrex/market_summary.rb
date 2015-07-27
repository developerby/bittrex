module Bittrex
  class MarketSummary
    attr_reader :name, :high, :low, :volume, :base_volume, :last, :bid, :ask, :open_buy_orders, :open_sell_orders, :prev_day, :created_at, :raw

    def initialize(attrs = {})
      @name = attrs['MarketName']
      @high = attrs['High']
      @low = attrs['Low']
      @volume = attrs['Volume']
      @last = attrs['Last']
      @base_volume = attrs['BaseVolume']
      @bid = attrs['Bid']
      @ask = attrs['Ask']
      @open_buy_orders = attrs['OpenBuyOrders']
      @open_sell_orders = attrs['OpenSellOrders']
      @prev_day = attrs['PrevDay']
      @created_at = Time.parse(attrs['Created'])
      @raw = attrs
    end

    def self.all
      client.get('public/getmarketsummaries').map{|data| new(data) }
    end

    def self.summary_by_pair(pair)
      response = client.get('public/getmarketsummary', market: pair)
      new(response.last) if response.present?
    end

    private

    def self.client
      @client ||= Bittrex.client
    end
  end
end