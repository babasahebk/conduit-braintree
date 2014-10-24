require 'conduit/braintree/json/base'

module Conduit::Driver::Braintree
  module Json
    class CreditCard < Base

      def item_options
        { credit_card: credit_card_attributes }
      end

      private

      def credit_card_attributes
        attr_names = Conduit::Driver::Braintree::CreateCreditCard::Parser.attributes

        attr_names.inject({}) do |h, attr_name|
          h.merge(attr_name => response.credit_card.send(attr_name))
        end
      end
    end
  end
end
