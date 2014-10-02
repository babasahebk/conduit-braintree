require 'conduit/braintree/parsers/base'

module Conduit::Driver::Braintree
  class RefundTransaction::Parser < Parser::Base

    attribute :transaction_id do
      @response_body[:transaction][:id]
    end

    attribute :transaction_type do
      @response_body[:transaction][:type]
    end

    attribute :transaction_amount do
      @response_body[:transaction][:amount]
    end

    attribute :transaction_status do
      @response_body[:transaction][:status]
    end

  end
end

