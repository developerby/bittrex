module Bittrex
  class Order < BaseBittrex
    attr_reader :type, :id, :limit,
                :exchange, :quantity, :remaining,
                :total, :fill, :executed_at, :commission, :rate, :raw, :error

    def initialize(attrs = {})
      @id = attrs['Uuid'] || attrs['OrderUuid']
      @type = (attrs['Type'] || attrs['OrderType']).to_s.capitalize
      @exchange = attrs['Exchange']
      @quantity = attrs['Quantity']
      @remaining = attrs['QuantityRemaining']
      @total = attrs['Price']
      @fill = attrs['FillType']
      @limit = attrs['Limit']
      @error = attrs['message']
      @commission = attrs['Commission']
      @rate = attrs['PricePerUnit']
      @raw = attrs
      fix_total if @total && @commission
      fix_commission if @commission && @rate
      exchange_total_and_quantity
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

    def self.by_uuid(uuid)
      history.detect { |e| e.id == uuid }
    end

    private

    def sell_order?
      @type == 'Limit_sell'
    end

    def fix_total
      @total = if sell_order?
        (@total.to_d - @commission.to_d).to_f
      else
        (@total.to_d + @commission.to_d).to_f
      end
    end

    def exchange_total_and_quantity
      @total, @quantity = @quantity, @total unless sell_order?
    end

    def fix_commission
      @commission = sell_order? ? @commission : (@commission.to_d / @rate.to_d).to_f
    end

    def self.orderbook(market, type, depth)
      client.get('public/getorderbook', {
        market: market,
        type: type,
        depth: depth
      })
    end
  end
end
