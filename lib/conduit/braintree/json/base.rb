module Conduit::Driver::Braintree
  module Json
    class Base

      attr_reader :response

      def initialize(response)
        @response = response
      end

      def to_json
        response_options = response.success? ? base_options.merge(item_options) : base_options
        MultiJson.dump(response_options)
      end

      private

      def base_options
        { successful: response.success?, errors: response.try(:errors) }
      end
    end
  end
end
