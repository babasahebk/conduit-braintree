module Conduit::Driver::Braintree
  module Json
    module Verification
      RESPONSE_CODE_ATTRIBUTES = %i[avs_postal_code_response_code
                                    avs_street_address_response_code
                                    cvv_response_code].freeze

      VERIFICATION_ATTRIBUTES  = %i[avs_error_response_code
                                    gateway_rejection_reason
                                    processor_response_code
                                    processor_response_text
                                    processor_response_type
                                    additional_processor_response
                                    verification_status] + RESPONSE_CODE_ATTRIBUTES

      private

      def verification_attributes
        return {} if verification.nil?
        VERIFICATION_ATTRIBUTES.inject({}) do |h, attr_name|
          if attr_name == :verification_code
            h.merge(attr_name => verification.status)
          elsif RESPONSE_CODE_ATTRIBUTES.include?(attr_name)
            response_code = verification.send(attr_name)
            h.merge(attr_name => translate_response_code(response_code))
          elsif verification.respond_to?(attr_name)
            h.merge(attr_name => verification.send(attr_name))
          else
            h.merge(attr_name => nil)
          end
        end
      end

      def translate_response_code(response_code)
        case response_code
        when "M" then "Matches"
        when "N" then "Does not match"
        when "U" then "Not verified"
        when "I" then "Not provided"
        when "A" then "Not applicable"
        else response_code
        end
      end

      def verification
        if response.respond_to?(:credit_card_verification) &&
            response.credit_card_verification.present?
          response.credit_card_verification
        elsif response.respond_to?(:transaction) && response.transaction.present?
          response.transaction
        elsif response.respond_to?(:credit_card) && response.credit_card.present?
          response.credit_card.verification
        end
      end
    end
  end
end
