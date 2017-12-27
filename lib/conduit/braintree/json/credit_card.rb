require "conduit/braintree/json/base"

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
          elsif attr_name == :billing_address
            h.merge(attr_name => billing_address_attributes)
          elsif attr_name == :customer_id
            h.merge(attr_name => response.credit_card.id)
          elsif response.credit_card.respond_to?(attr_name)
            h.merge(attr_name => response.credit_card.send(attr_name))
          else
            h.merge(attr_name => nil)
          end
        end
      end

      def billing_address_attributes
        [
          :company,
          :country_code_alpha2,
          :country_code_alpha3,
          :country_code_numeric,
          :country_name,
          :created_at,
          :customer_id,
          :extended_address,
          :first_name,
          :id,
          :last_name,
          :locality,
          :postal_code,
          :region,
          :street_address,
          :updated_at
        ].inject({}) do |h, prop|
          h[prop] = response.credit_card.billing_address.try(prop)
          h
        end
      end
    end
  end
end
