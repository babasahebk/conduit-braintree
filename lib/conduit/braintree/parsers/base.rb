require "multi_json"

module Conduit::Driver::Braintree
  module Parser
    class Base < Conduit::Core::Parser
      attr_reader :json, :http_status

      def initialize(response_body, http_status = nil)
        response_body ||= "{}"
        @json = MultiJson.load(response_body, symbolize_keys: true)
        @http_status = http_status
      rescue MultiJson::ParseError
        @json = { errors: ["Unable to parse response"] }
      end

      def response_status
        data = json
        object_path("successful") ? "success" : "failure"
      end

      def error_type
        return if object_path("successful")
        hard_error_message? ? "hard" : "soft"
      end

      def hard_error_message?
        msg = errors.map(&:message).join(",")
        Conduit::Braintree.hard_error_codes.any? { |code| msg.match?(code) }
      end

      # Returns a hash of errors reported by Braintree
      # If no errors were reported, returns an empty hash
      #
      def errors
        @errors ||= normalized_errors
      end

      # Alias errors as required response_errors method
      alias response_errors errors

      def object_path(path)
        data = json
        path.split("/").map do |element|
          key = element.match?(/\A\d+\Z/) ? element.to_i : element.to_sym
          data = data.nil? ? nil : data[key]
        end.last
      end

      private

      def normalized_errors
        return [] if object_path("successful")

        # if it's not successful, and we have no other error details,
        # just return the wrapped message
        if object_path("message") && !detailed_errors?
          [Conduit::Error.new(message: object_path("message"))]
        else
          normalized_error_objects
        end
      end

      def detailed_errors?
        object_path("errors").present?
      end

      def normalized_error_objects
        return [] unless object_path("errors")
        object_path("errors").map do |attribute, error_messages|
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
