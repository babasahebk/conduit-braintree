require "spec_helper"

describe Conduit::Driver::Braintree::CreateCreditCard do
  subject do
    described_class.new(options).perform.parser
  end

  let(:options) do
    { merchant_id:      "hello-labs-1",
      private_key:      "hello-labs-ssh",
      public_key:       "hello-world",
      environment:      :sandbox,
      mock_status:      mock_status,
      customer_id:      "k4rs72_1",
      cardholder_name:  "John Doe",
      number:           "4111111111111111",
      cvv:              "123",
      expiration_month: 12,
      expiration_year:  2099,
      billing_address:  { street_address: "321 Main St", postal_code: "12345" },
      verification_merchant_account_id: "TESTIT" }
  end

  let(:amount) { 10 }

  describe "#perform" do
    context "with a successful authorization" do
      let(:mock_status)       { "success" }
      its(:response_status)   { should eql mock_status }
      its(:cardholder_name)   { should eql options[:cardholder_name] }
      its(:expiration_month)  { should eql options[:expiration_month].to_s }
      its(:expiration_year)   { should eql options[:expiration_year].to_s }
      its(:card_type)         { should eql "Visa" }
      its(:bin)               { should eql "411111" }
      its(:last_four)         { should eql "1111" }
      its(:token)             { should_not be_empty }
      its(:message)           { should be_nil }
      its(:billing_address)   { should include(postal_code: "12345") }
      its(:billing_address)   { should include(street_address: "321 Main St") }
    end

    context "with a failure authorizing" do
      let(:mock_status)        { "failure" }
      its(:response_status)    { should eql mock_status }
      its(:errors) do
        expected = [
          Conduit::Error.new(attribute: :merchant_id,
            message: "Invalid verification merchant account ID (917218)")
        ]
        should eql expected
      end
    end
  end
end
