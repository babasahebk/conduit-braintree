module Conduit::Driver::Braintree
  class ClientToken < Base
    optional_attributes :customer_id, :merchant_account_id

    private

    def perform_request
      @raw_response = Braintree::ClientToken.generate(whitelist_options)
      body = { client_token: @raw_response, successful: true }.to_json
    end
  end
end
