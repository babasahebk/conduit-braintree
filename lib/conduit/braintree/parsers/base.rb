require "multi_json"

module Conduit::Driver::Braintree
  module Parser
    class Base < Conduit::Core::Parser
      HARD_ERROR_CODES = [
       "2004", "2005", "2006", "2007", "2008",
       "2010", "2011", "2012", "2013", "2014",
       "2015", "2017", "2018", "2019", "2020",
       "2022", "2023", "2024", "2027", "2028",
       "2029", "2030", "2031", "2032", "2036",
       "2037", "2039", "2041", "2043", "2044",
       "2045", "2047", "2049", "2051", "2053",
       "2055", "2056", "2058", "2059", "2060",
       "2061", "2063", "2064", "2065", "2066",
       "2067", "2068", "2069", "2070", "2071",
       "2072", "2073", "2074", "2075", "2076",
       "2077", "2079", "2081", "2082", "2083",
       "2084", "2085", "2086", "2087", "2088",
       "2089", "2090", "2091"
      ].freeze

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
        HARD_ERROR_CODES.any? { |code| msg.match?(code) }
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
