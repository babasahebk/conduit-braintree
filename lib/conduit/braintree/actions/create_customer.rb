require "conduit/braintree/json/customer"
require "conduit/braintree/actions/base"

module Conduit::Driver::Braintree
  class CreateCustomer < Base
    required_attributes :customer_id
    optional_attributes :first_name, :last_name, :company, :email, :phone, :fax,
                        :website, :device_data

    private

    def perform_request
      create_options = whitelist_options.except(:customer_id)
      create_options[:id] = @options[:customer_id]
      create_options[:device_data] = @options[:device_data] unless @options[:device_data].blank?

      response = Braintree::Customer.create(create_options)
      body     = Conduit::Driver::Braintree::Json::Customer.new(response).to_json

      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: response, body: body, parser: parser)
    rescue Braintree::BraintreeError => error
      report_braintree_exceptions(error)
    end
  end
end
