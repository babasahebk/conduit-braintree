require 'multi_json'

module Conduit::Driver::Braintree
  module Parser
    class Base < Conduit::Core::Parser

      attr_reader :json

      def initialize(response_body)
        @json = MultiJson.load(response_body, symbolize_keys: true)
      end

      def response_status
        data = json
        object_path('successful') ? 'success' : 'failure'
      end

      def errors
        object_path('errors') || []
      end

      def object_path(path)
        data = json
        path.split('/').map do |element|
          key = element.match(/\A\d+\Z/) ? element.to_i : element.to_sym
          data = data[key]
        end.last
      end
    end
  end
end