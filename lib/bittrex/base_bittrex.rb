module Bittrex
  class BaseBittrex
    private

    def self.client
      @client ||= Bittrex.client
    end

    def self.normalize_response(response)
      response.is_a?(Array) ? response.last : response
    end
  end
end