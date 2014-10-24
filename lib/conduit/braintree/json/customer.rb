require 'conduit/braintree/json/base'

module Conduit::Driver::Braintree
  module Json
    class Customer < Base

      def item_options
        { customer: customer_attributes }
      end

      private

      def customer_attributes
        attr_names = Conduit::Driver::Braintree::CreateCustomer::Parser.attributes
        attr_names.delete(:customer_id).add(:id)

        attr_names.inject({}) do |h, attr_name|
          h.merge(attr_name => response.customer.send(attr_name))
        end
      end
    end
  end
end
