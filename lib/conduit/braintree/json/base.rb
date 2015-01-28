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
          response.errors.inject({}) do |errors, error|
            attr_id = error.attribute || :base
            attr_id = attr_id.to_s.underscore.to_sym
            val = errors[attr_id] || []
            val.push("#{error.message} (#{error.code})")
            errors.merge(attr_id => val)
          end
        else
          []
        end

        { successful: response.respond_to?(:success?) ? response.success? : true,
          errors:     errors }
      end
    end
  end
end
