require 'conduit/braintree/json/base'

module Conduit::Driver::Braintree
  module Json
    class CreditCard < Base
      def item_options
        { credit_card: credit_card_attributes.merge(verification_attributes) }
      end

      private

      def credit_card_attributes
        attr_names = Conduit::Driver::Braintree::CreateCreditCard::Parser.attributes

        attr_names.inject({}) do |h, attr_name|
          next h if attr_name == :message

          if attr_name == :last_four
            h.merge(attr_name => response.credit_card.last_4)
          elsif attr_name == :customer_id
            h.merge(attr_name => response.credit_card.id)
          elsif response.credit_card.respond_to?(attr_name)
            h.merge(attr_name => response.credit_card.send(attr_name))
          else
            h.merge(attr_name => nil)
          end
        end
      end
    end
  end
end
