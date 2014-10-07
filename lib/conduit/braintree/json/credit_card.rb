require 'conduit/braintree/json/base'

module Conduit::Driver::Braintree
  module Json
    class CreditCard < Base

      def item_options
        {
          credit_card: {
            token:            response.credit_card.token,
            bin:              response.credit_card.bin,
            card_type:        response.credit_card.card_type,
            cardholder_name:  response.credit_card.cardholder_name,
            expiration_month: response.credit_card.expiration_month,
            expiration_year:  response.credit_card.expiration_year,
            last_four:        response.credit_card.last_4
          }
        }
      end
    end
  end
end
