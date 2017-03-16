require "spec_helper"

describe Conduit::Driver::Braintree::VoidTransaction do
  subject do
    described_class.new(options).perform.parser
  end

  let(:options) do
    { merchant_id:      "hello-labs-1",
      private_key:      "hello-labs-ssh",
      public_key:       "hello-world",
      environment:      :sandbox,
      reference_number: "k4rs72",
      mock_status:      mock_status }
  end

  let(:amount) { 10 }

  describe "#perform" do
    context "with a successful authorization" do
      let(:mock_status) { "success" }
      its(:response_status)    { should eql mock_status }
      its(:transaction_status) { should eql "voided" }
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
