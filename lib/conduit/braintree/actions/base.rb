require "conduit/braintree/json/credit_card"

module Conduit::Driver::Braintree
  class Base < Conduit::Core::Action
    def self.inherited(base)
      base.send :required_attributes, *Conduit::Driver::Braintree.credentials
      base.send :required_attributes,
        *Conduit::Driver::Braintree.required_attributes
      base.send :optional_attributes,
        *Conduit::Driver::Braintree.optional_attributes
    end

    attr_accessor :options

    def initialize(options)
      super(options)
      expand_device_data
      configure_braintree
    end

    # Performs the request, with mocking if requested
    #
    def perform
      body = perform_action
      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: @raw_response, body: body, parser: parser)
    rescue Braintree::NotFoundError => error
      report_braintree_exceptions(error)
    rescue ArgumentError => error
      respond_with_error(error.message)
    rescue Braintree::BraintreeError => error
      report_braintree_exceptions(error)
    rescue Net::ReadTimeout, Net::OpenTimeout, Errno::ETIMEDOUT
      respond_with_error("Braintree timeout")
    end

    def perform_action
      if mock_mode?
        mocker = request_mocker.new(self, @options)
        mocker.with_mocking { perform_request }
      else
        perform_request
      end
    end

    def report_braintree_exceptions(exception)
      case exception.class.name
      when "Braintree::AuthenticationError"
        respond_with_error("Braintree API credentials incorrect")
      when "Braintree::AuthorizationError"
        respond_with_error("Braintree action not authorized")
      when "Braintree::ConfigurationError"
        respond_with_error("Braintree not configured")
      when "Braintree::DownForMaintenanceError"
        respond_with_error("Braintree unavailable")
      when "Braintree::SSLCertificateError"
        respond_with_error("Braintree SSL certificate error")
      when "Braintree::UpgradeRequiredError"
        respond_with_error("Braintree upgrade required")
      when "Braintree::NotFoundError"
        identifier = @options[:token] || @options[:customer_id]
        respond_with_error("Failed to find resource with identifier #{identifier}")
      else
        respond_with_error("Braintree error")
      end
    end

    def respond_with_error(message)
      response = OpenStruct.new(success?: false,
        errors: [OpenStruct.new(attribute: :base, code: "error", message: message)])
      body = Conduit::Driver::Braintree::Json::CreditCard.new(response).to_json

      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: body, body: body, parser: parser)
    end

    private

    def whitelist_options
      @options.slice(*attributes).except(:mock_status)
    end

    def configure_braintree
      configuration_keys = Conduit::Driver::Braintree.credentials +
                           Conduit::Driver::Braintree.required_attributes

      configuration_keys.each do |key|
        val = @options[key]
        val = val.to_sym if key == :environment

        ::Braintree::Configuration.send "#{key}=", val
        @options.delete(key)
      end
    end

    def request_mocker
      "Conduit::Braintree::RequestMocker::#{action_name}".constantize
    end

    def action_name
      self.class.name.split("::").last
    end

    def mock_mode?
      @options.key?(:mock_status)
    end

    def expand_device_data
      return unless @options[:device_data].is_a?(Hash)
      @options.merge!(@options.delete(:device_data))
    end
  end
end
