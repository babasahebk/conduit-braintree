require 'multi_json'

module Conduit::Driver::Braintree
  module Parser
    class Base < Conduit::Core::Parser

      attr_reader :credit_card

      def initialize(response_body)
        @response_body = MultiJson.load(response_body, symbolize_keys: true)
        @credit_card = @response_body[:credit_card]
      end

      def response_status
        @response_body[:successful] ? 'success' : 'failure'
      end

      def errors
        @response_body[:errors] || []
      end
    end
  end
end
