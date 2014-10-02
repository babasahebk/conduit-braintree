require 'conduit/braintree/configuration'

module Conduit::Driver::Braintree
  class UpdateCreditCard < Conduit::Core::Action

    required_attributes :token, :cardholder_name, :number, :cvv,
                        :expiration_month, :expiration_year, :billing_address

    # Required entry method, the main driver
    # class will use this to trigger the
    # request.
    #
    def perform
      response = Braintree::CreditCard.update(@options[:token], @options)
      if response.success?
        body = MultiJson.dump({
          successful: response.success?,
          credit_card: {
            token: response.credit_card.token,
            bin: response.credit_card.bin,
            card_type: response.credit_card.card_type,
            cardholder_name: response.credit_card.cardholder_name,
            expiration_month: response.credit_card.expiration_month,
            expiration_year: response.credit_card.expiration_year,
            last_four: response.credit_card.last_4
          }
        })
      else
        body = MultiJson.dump({
          successful: response.success?,
          errors: response.errors
        })
      end

      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: response, body: body, parser: parser)
    end
  end
end
