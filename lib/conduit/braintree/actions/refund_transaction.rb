require 'conduit/braintree/configuration'

module Conduit::Driver::Braintree
  class RefundTransaction < Conduit::Core::Action

    required_attributes :reference_number, :amount

    # Required entry method, the main driver
    # class will use this to trigger the
    # request.
    #
    def perform
      response = Braintree::Transaction.refund(
                   @options[:reference_number], @options[:amount])
      if response.success?
        body = MultiJson.dump({
          successful: response.success?,
          transaction: {
            id: response.transaction.id,
            type: response.transaction.type,
            amount: response.transaction.amount,
            status: response.transaction.status
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
