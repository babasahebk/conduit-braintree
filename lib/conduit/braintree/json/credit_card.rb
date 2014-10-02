module Conduit::Driver::Braintree
  module Json
    class CreditCard
      def initialize(response)
        @response = response
      end

      def to_json
        if @response.success?
          MultiJson.dump({
            successful: @response.success?,
            credit_card: {
              token: @response.credit_card.token,
              bin: @response.credit_card.bin,
              card_type: @response.credit_card.card_type,
              cardholder_name: @response.credit_card.cardholder_name,
              expiration_month: @response.credit_card.expiration_month,
              expiration_year: @response.credit_card.expiration_year,
              last_four: @response.credit_card.last_4
            }
          })
        else
          MultiJson.dump({
            successful: response.success?,
            errors: response.errors
          })
        end
      end
    end
  end
end
