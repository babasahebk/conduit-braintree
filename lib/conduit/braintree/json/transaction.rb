require 'conduit/braintree/json/base'

module Conduit::Driver::Braintree
  module Json
    class Transaction < Base

      def item_options
        { transaction: transaction_attributes }
      end

      private

      def transaction_attributes
        attr_names = Conduit::Driver::Braintree::AuthorizeTransaction::Parser.
          attributes

        attr_names.inject({}) do |h, attr_name|
          h.merge(attr_name => response.transaction.send(attr_name))
        end
      end
    end
  end
end
