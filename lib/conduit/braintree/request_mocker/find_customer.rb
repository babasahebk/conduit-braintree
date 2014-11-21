require 'conduit/braintree/request_mocker/base'

module Conduit::Braintree::RequestMocker
  class FindCustomer < Base
    def mock
      if @mock_status == :failure
        @stub = stub_request(:any, /braintree/).
          to_return(body: nil, status: 404, headers: {})
      else
        super
      end
    end
  end
end
