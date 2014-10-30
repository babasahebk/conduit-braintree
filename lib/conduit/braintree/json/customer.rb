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

        response_object = response.respond_to?(:customer) ? response.customer : response

        attr_names.inject({}) do |h, attr_name|
          if attr_name == :customer_id
            h.merge(id: response_object.id)
          else
            h.merge(attr_name => response_object.try(attr_name))
          end
        end
      end
    end
  end
end
