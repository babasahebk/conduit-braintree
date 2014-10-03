module Conduit::Driver::Braintree
  module Json
    class Transaction
      def initialize(response)
        @response = response
      end

      def to_json
        if response.success?
          body = MultiJson.dump({
            successful: response.success?,
            transaction: {
              id: response.transaction.id,
              type: response.transaction.type,
              amount: response.transaction.amount,
              status: response.transaction.status
            }
          })
        else
          body = MultiJson.dump({
            successful: response.success?,
            errors: response.errors
          })
        end
      end
    end
  end
end
