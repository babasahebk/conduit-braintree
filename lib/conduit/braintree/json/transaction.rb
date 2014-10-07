require 'conduit/braintree/json/base'

module Conduit::Driver::Braintree
  module Json
    class Transaction < Base

      def item_options
        {
          transaction: {
            id:     response.transaction.id,
            type:   response.transaction.type,
            amount: response.transaction.amount,
            status: response.transaction.status
          }
        }
      end
    end
  end
end
