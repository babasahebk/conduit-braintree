require 'conduit/braintree/parsers/base'

module Conduit::Driver::Braintree
  class AuthorizeTransaction::Parser < Parser::Base

    attribute :transaction_id do
      object_path('transaction/id')
    end

    attribute :transaction_type do
      object_path('transaction/type')
    end

    attribute :transaction_amount do
      BigDecimal(object_path('transaction/amount'))
    end

    attribute :transaction_status do
      object_path('transaction/status')
    end

    attribute :message do
      object_path('transaction/message')
    end
  end
end

