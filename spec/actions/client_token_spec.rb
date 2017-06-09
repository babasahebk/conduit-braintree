require "spec_helper"

describe Conduit::Driver::Braintree::ClientToken do
  subject do
    described_class.new(options).perform.parser
  end

  let(:options) do
    {
      merchant_id:      "hello-labs-1",
      private_key:      "hello-labs-ssh",
      public_key:       "hello-world",
      environment:      :sandbox,
      mock_status:      mock_status
    }
  end

  describe "view" do
    let(:mock_status) { "success" }

    it "is empty" do
      expect(described_class.new(options).view).to eql ""
    end
  end

  describe "#perform" do
    let(:mock_status)       { "success" }
    its(:response_status)   { should eql mock_status }
    its(:client_token)      { should_not eql nil }
  end

  context "with a failure authorizing" do
    let(:mock_status)        { "failure" }
    its(:response_status)    { should eql mock_status }
    its(:errors) do
      expected = [
        Conduit::Error.new(attribute: :base,
          message: "Invalid verification merchant account ID (error)")
      ]
      should eql expected
    end
  end
end
