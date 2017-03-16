require "conduit/braintree/json/base"

module Conduit::Driver::Braintree
  module Json
    class Transaction < Base
      include Verification

      def item_options
        { transaction: transaction_attributes.merge(verification_attributes) }
      end

      private

      def transaction_attributes
        attr_names = Conduit::Driver::Braintree::AuthorizeTransaction::Parser.
                     attributes

        attr_names.inject({}) do |h, attr_name|
          if attr_name =~ /transaction/
            transaction_attr = attr_name.to_s.gsub(/transaction_/, "")

            h.merge(transaction_attr => response.transaction.send(transaction_attr))
          else
            value = response.respond_to?(attr_name) ? response.send(attr_name) : nil
            h.merge(attr_name.to_s => value)
          end
        end
      end
    end
  end
end
