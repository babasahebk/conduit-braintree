require 'conduit/braintree/parsers/base'

module Conduit::Driver::Braintree
  class UpdateCreditCard::Parser < Parser::Base

    attribute :expiration_month do
      object_path('credit_card/expiration_month')
    end

    attribute :expiration_year do
      object_path('credit_card/expiration_year')
    end

    attribute :card_type do
      object_path('credit_card/card_type')
    end

    attribute :last_four do
      object_path('credit_card/last_four')
    end

    attribute :token do
      object_path('credit_card/token')
    end

    attribute :bin do
      object_path('credit_card/bin')
    end
  end
end
