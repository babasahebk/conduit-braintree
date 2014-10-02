module Conduit
  module Driver
    # Conduit Driver for the Braintree Api
    module Braintree
      extend Conduit::Core::Driver

      required_credentials :validation_key, :customer_id

      action :create_credit_card
      action :update_credit_card
      action :delete_credit_card
      action :authorize_transaction
      action :void_transaction
      action :settle_transaction
      action :refund_transaction

    end
  end
end
