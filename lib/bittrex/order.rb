module Bittrex
  class Order
    attr_reader :type, :id, :limit,
                :exchange, :quantity, :remaining,
                :total, :fill, :executed_at, :commission, :rate, :raw

    def initialize(attrs = {})
      @id = attrs['Uuid'] || attrs['OrderUuid']
      @type = (attrs['Type'] || attrs['OrderType']).to_s.capitalize
      @exchange = attrs['Exchange']
      @quantity = attrs['Quantity']
      @remaining = attrs['QuantityRemaining']
      @total = attrs['Price']
      @fill = attrs['FillType']
      @limit = attrs['Limit']
      @commission = attrs['Commission']
      @rate = attrs['PricePerUnit']
      @raw = attrs
      # @executed_at = Time.parse(attrs['TimeStamp'])
    end

    def self.book(market, type, depth = 50)
      orders = []

      if type.to_sym == :both
        orderbook(market, type.downcase, depth).each_pair do |type, values|
          values.each do |data|
            orders << new(data.merge('Type' => type))
          end
        end
      else
        orderbook(market, type.downcase, depth).each do |data|
          orders << new(data.merge('Type' => type))
        end
      end

      orders
    end

    def self.open
      client.get('market/getopenorders').map{|data| new(data) }
    end

    def self.cancel_order(uuid)
      client.get('market/cancel', uuid: uuid)
    end

    def self.history
      client.get('account/getorderhistory').map{|data| new(data) }
    end

    def self.history_order_by_uuid(uuid)
      history.detect { |e| e.id == uuid }
    end

    private

    def self.orderbook(market, type, depth)
      client.get('public/getorderbook', {
        market: market,
        type: type,
        depth: depth
      })
    end

    def self.client
      @client ||= Bittrex.client
    end
  end
end
