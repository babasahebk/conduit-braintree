require 'multi_json'

module Conduit::Driver::Braintree
  module Parser
    class Base < Conduit::Core::Parser

      attr_reader :json

      def initialize(response_body)
        response_body ||= '{}'
        @json = MultiJson.load(response_body, symbolize_keys: true)
      rescue MultiJson::ParseError
        @json = {errors: ['Unable to parse response']}
      end

      def response_status
        data = json
        object_path('successful') ? 'success' : 'failure'
      end

      # Returns a hash of errors reported by Braintree
      # If no errors were reported, returns an empty hash
      #
      def errors
        @errors ||= normalized_errors
      end

      # Alias errors as required response_errors method
      alias_method :response_errors, :errors

      def object_path(path)
        data = json
        path.split('/').map do |element|
          key = element.match(/\A\d+\Z/) ? element.to_i : element.to_sym
          data = data.nil? ? nil : data[key]
        end.last
      end

      private

      def normalized_errors
        response_errors = object_path('errors')
        return [] unless response_errors

        response_errors.map do |attribute, error_messages|
          if error_messages.nil?
            # if the error_messages is nil, the attribute is just a message
            Conduit::Error.new(message: attribute)
          else
            # error is array of messages, explode into unique errors.
            error_messages.map do |message|
              Conduit::Error.new(message: message, attribute: attribute)
            end
          end
        end.flatten
      end
    end
  end
end
