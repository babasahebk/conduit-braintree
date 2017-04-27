require "conduit/braintree/parsers/base"

module Conduit::Driver::Braintree
  class ClientToken::Parser < Parser::Base
    attribute :client_token do
      object_path("client_token")
    end
  end
end
