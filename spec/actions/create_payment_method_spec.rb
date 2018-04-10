require "spec_helper"

describe Conduit::Driver::Braintree::CreatePaymentMethod do
  let(:mock_status) { "success" }
  let(:options) do
    {
      merchant_id:          "hello-labs-1",
      private_key:          "hello-labs-ssh",
      public_key:           "hello-world",
      environment:          :sandbox,
      mock_status:          mock_status,
      payment_method_nonce: "Sid and Noncy",
      customer_id:          "customer-1",
      device_data: {
        device_session_id: "572da92539d8c567182a1ef139ea498c",
        fraud_merchant_id: "600000"
      }
    }
  end

  subject { described_class.new(options) }

  context "expanding device_data" do
    context "when device_data is a string" do
      it "keeps device_data in options" do
        options[:device_data] = "somestring"
        expect(subject.options.key?(:device_data)).to eql(true)
        expect(subject.options.key?(:device_session_id)).to eql(false)
        expect(subject.options.key?(:fraud_merchant_id)).to eql(false)
      end
    end

    context "when device_data is a hash" do
      it "replaces device_data with child params" do
        expect(subject.options.key?(:device_data)).to eql(false)
        expect(subject.options.key?(:device_session_id)).to eql(true)
        expect(subject.options.key?(:fraud_merchant_id)).to eql(true)
      end
    end
  end

  describe "#perform" do
    subject { described_class.new(options).perform.parser }

    its(:response_status)   { should eql mock_status }
    its(:token)             { should_not be_empty }
    its(:billing_address)   { should include(postal_code: "29650") }
    its(:billing_address)   { should include(street_address: "123 Main St") }

    context "with a failure authorizing" do
      let(:mock_status)        { "failure" }
      its(:response_status)    { should eql mock_status }
      its(:errors) do
        expected = [
          Conduit::Error.new(attribute: :base,
            message: "917218: Invalid verification merchant account ID. Transaction Declined (error)")
        ]
        should eql expected
      end
    end
  end
end
