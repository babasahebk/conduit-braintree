require 'conduit/braintree/json/credit_card'

module Conduit::Driver::Braintree
  class Base < Conduit::Core::Action

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
  end
end
