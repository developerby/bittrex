module Bittrex
  class Deposit < BaseBittrex
    attr_reader :id, :transaction_id, :address, :quantity, :currency, :confirmations, :executed_at, :error

    def initialize(attrs = {})
      @id = attrs['Id']
      @transaction_id = attrs['TxId']
      @address = attrs['CryptoAddress']
      @quantity = attrs['Amount']
      @currency = attrs['Currency']
      @confirmations = attrs['Confirmations']
      @error = attrs['message']
      @executed_at = Time.parse(attrs['LastUpdated']) if attrs['LastUpdated'].present?
    end

    def self.all
      client.get('account/getdeposithistory').map{|data| new(data) }
    end

    def self.transaction(transaction_id)
      all.detect do |transaction|
        transaction.transaction_id == transaction_id
      end
    end
  end
end
