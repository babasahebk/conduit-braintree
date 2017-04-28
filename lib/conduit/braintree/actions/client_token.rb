module Conduit::Driver::Braintree
  class ClientToken < Base
    private

    def perform_request
      response = Braintree::ClientToken.generate
      body = { client_token: response, successful: true }.to_json
      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: response, body: body, parser: parser)
    rescue ArgumentError => error
      respond_with_error(error.message)
    rescue Braintree::BraintreeError => error
      report_braintree_exceptions(error)
    end
  end
end