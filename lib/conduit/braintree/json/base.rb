module Conduit::Driver::Braintree
  module Json
    class Base

      attr_reader :response

      def initialize(response)
        @response = response
      end

      def to_json
        MultiJson.dump(response_options)
      end

      private

      def response_options
        base_options.tap do |options|
          options.merge!(item_options) unless options[:errors].any?
        end
      end

      def base_options
        errors = if response.respond_to?(:errors) 
                   response.errors.map { |e| "#{e.message} (#{e.code})" }
                 else
                   []
                 end

        { successful: response.try(:success?) || true, errors: errors }
      end
    end
  end
end
