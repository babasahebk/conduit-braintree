require 'conduit/braintree/json/customer'
require 'conduit/braintree/actions/base'

module Conduit::Driver::Braintree
  class CreateCustomer < Base

    required_attributes :customer_id
    optional_attributes :first_name, :last_name, :company, :email, :phone, :fax,
                        :website

    private

    def perform_request
      create_options = @options.except(:customer_id)
      create_options.merge!(id: @options[:customer_id])

      response = Braintree::Customer.create(create_options)
      body     = Conduit::Driver::Braintree::Json::Customer.new(response).to_json

      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: response, body: body, parser: parser)
    rescue Braintree::BraintreeError => error
      report_braintree_exceptions(error)
    end
  end
end
