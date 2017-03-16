require "conduit/braintree/request_mocker/base"

module Conduit::Braintree::RequestMocker
  class DeleteCreditCard < Base
    def mock
      if @mock_status == :failure
        @status = 404
      elsif @mock_status == :success
        @status = 200
      end
      super
    end
  end
end
