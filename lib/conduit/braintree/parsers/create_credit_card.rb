require 'conduit/braintree/parsers/base'

module Conduit::Driver::Braintree
  class CreateCreditCard::Parser < Parser::Base

    attribute :expiration_month do
      credit_card[:expiration_month]
    end

    attribute :expiration_year do
      credit_card[:expiration_year]
    end

    attribute :card_type do
      credit_card[:card_type]
    end

    attribute :last_four do
      credit_card[:last_four]
    end

    attribute :token do
      credit_card[:token]
    end

    attribute :bin do
      credit_card[:bin]
    end
  end
end
