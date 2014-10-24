require 'conduit/braintree/parsers/base'

module Conduit::Driver::Braintree
  class CreateCustomer::Parser < Parser::Base

    attribute :customer_id do
      object_path('customer/id')
    end

    attribute :first_name do
      object_path('customer/first_name')
    end

    attribute :last_name do
      object_path('customer/last_name')
    end

    attribute :company do
      object_path('customer/company')
    end

    attribute :phone do
      object_path('customer/phone')
    end

    attribute :fax do
      object_path('customer/fax')
    end

    attribute :email do
      object_path('customer/email')
    end

    attribute :website do
      object_path('customer/website')
    end

  end
end
