module Conduit
  module Driver
    # Conduit Driver for the Braintree Api
    module Braintree
      extend Conduit::Core::Driver

      required_credentials :merchant_id, :private_key, :public_key
      required_attributes  :environment
      optional_attributes  :mock_status, :merchant_account_id

      action :create_customer
      action :find_customer
      action :create_credit_card
      action :update_credit_card
      action :delete_credit_card
      action :authorize_transaction
      action :void_transaction
      action :settle_transaction
      action :refund_transaction
      action :find_transaction
      action :client_token
    end
  end
end
