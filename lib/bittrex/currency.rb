module Bittrex
  class Currency < BaseBittrex
    attr_reader :name, :abbreviation, :minimum_confirmation, :transaction_fee, :active, :raw, :error

    alias_method :min_confirmation, :minimum_confirmation
    alias_method :fee, :transaction_fee

    def initialize(attrs = {})
      @name = attrs['CurrencyLong']
      @abbreviation = attrs['Currency']
      @transaction_fee = attrs['TxFee']
      @minimum_confirmation = attrs['MinConfirmation']
      @active = attrs['IsActive']
      @error = attrs['message']
      @raw = attrs
    end

    def self.all
      client.get('public/getcurrencies').map{|data| new(data) }
    end

    def self.by_currency(abbreviation)
      all.detect{ |e| e.abbreviation == abbreviation }
    end
  end
end
