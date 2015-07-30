module Bittrex
  class Wallet < BaseBittrex
    attr_reader :id, :currency, :balance, :available, :pending, :address, :requested, :raw, :error

    def initialize(attrs = {})
      @id = attrs['Uuid'].to_s
      @address = attrs['CryptoAddress']
      @currency = attrs['Currency']
      @balance = attrs['Balance']
      @available = attrs['Available']
      @pending = attrs['Pending']
      @error = attrs['message']
      @raw = attrs
      @requested = attrs['Requested']
    end

    def self.all
      client.get('account/getbalances').map{|data| new(data) }
    end

    def self.by_currency(currency)
      all.detect { |e| e.currency == currency }
    end
  end
end
