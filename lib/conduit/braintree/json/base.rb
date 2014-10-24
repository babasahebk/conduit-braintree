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
        if response.success?
          base_options.merge(item_options)
        else
          base_options
        end
      end

      def base_options
        errors = if response.respond_to?(:errors) 
                   response.errors.map { |e| "#{e.message} (#{e.code})" }
                 else
                   []
                 end

        { successful: response.success?, errors: errors }
      end
    end
  end
end
