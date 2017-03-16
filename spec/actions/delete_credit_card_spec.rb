require "spec_helper"

describe Conduit::Driver::Braintree::DeleteCreditCard do
  subject do
    described_class.new(options).perform.parser
  end

  let(:options) do
    { merchant_id:      "hello-labs-1",
      private_key:      "hello-labs-ssh",
      public_key:       "hello-world",
      environment:      :sandbox,
      mock_status:      mock_status,
      token:            "24sss2" }
  end

  let(:amount) { 10 }

  describe "#perform" do
    context "with a successful authorization" do
      let(:mock_status)       { "success" }
      its(:response_status)   { should eql mock_status }
    end

    context "with a failure authorizing" do
      let(:mock_status)        { "failure" }
      its(:response_status)    { should eql mock_status }
      its(:errors) do
        expected = [
          Conduit::Error.new(attribute: :base,
            message: "Failed to find resource with identifier 24sss2 (error)")
        ]
        should eql expected
      end
    end
  end
end
