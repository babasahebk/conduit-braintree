require 'conduit/braintree/parsers/base'

module Conduit::Driver::Braintree
  class VoidTransaction::Parser < Parser::Base

    attribute :transaction_id do
      object_path('transaction/id')
    end

    attribute :transaction_type do
      object_path('transaction/type')
    end

    attribute :transaction_amount do
      object_path('transaction/amount')
    end

    attribute :transaction_status do
      object_path('transaction/status')
    end

  end
end
