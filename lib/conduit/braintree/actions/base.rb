require 'conduit/braintree/json/credit_card'

module Conduit::Driver::Braintree
  class Base < Conduit::Core::Action
    def self.inherited(base)
      base.send :required_attributes, *(Conduit::Driver::Braintree.credentials)
      base.send :required_attributes,
        *(Conduit::Driver::Braintree.required_attributes)
      base.send :optional_attributes,
        *(Conduit::Driver::Braintree.optional_attributes)
    end

    def initialize(options)
      super(options)
      configure_braintree
    end

    def report_exception_as_error(exception)
      case exception.class.name
      when 'Braintree::AuthenticationError'
        respond_with_error('Braintree API credentials incorrect')
      when 'Braintree::AuthorizationError'
        respond_with_error('Braintree action not authorized')
      when 'Braintree::ConfigurationError'
        respond_with_error('Braintree not configured')
      when 'Braintree::DownForMaintenanceError'
        respond_with_error('Braintree unavailable')
      when 'Braintree::SSLCertificateError'
        respond_with_error('Braintree SSL certificate error')
      when 'Braintree::UpgradeRequiredError'
        respond_with_error('Braintree upgrade required')
      when 'Braintree::NotFoundError'
        respond_with_error("Failed to find card with token #{@options[:token]}")
      else
        respond_with_error('Braintree error')
      end
    end

    def respond_with_error(message)
      body = MultiJson.dump({
        successful: false,
        errors: [{
          attribute: :base,
          code: 'error',
          message: message
        }]
      })

      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: body, body: body, parser: parser)
    end

    private

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
  end
end
