require "spec_helper"

describe Conduit::Driver::Braintree::AuthorizeTransaction do
  subject do
    described_class.new(options).perform.parser
  end

  let(:options) do
    { merchant_id: "hello-labs-1",
      merchant_account_id: "hello-labs-customer-1",
      private_key: "hello-labs-ssh",
      public_key:  "hello-world",
      environment: :sandbox,
      amount:      amount,
      token:       "test-101",
      mock_status: mock_status }
  end

  let(:amount) { 10 }

  describe "#perform" do
    context "with a successful authorization" do
      let(:mock_status) { "success" }
      its(:response_status)    { should eql mock_status }
      its(:transaction_status) { should eql "authorized" }
      its(:transaction_amount) { should eql amount }
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

    context "with a processor failure" do
      let(:mock_status) { "processor_failure" }
      it "returns a failure message" do
        expect(subject.message).to eql "Limit Exceeded (2002)"
        expect(subject.error_type).to eql "soft"
      end
    end

    context "with a processor failure" do
      let(:mock_status) { "gateway_failure" }
      it "returns a failure message" do
        expect(subject.message).to eql "Gateway Rejected: fraud (2004)"
        expect(subject.error_type).to eql "hard"
      end
    end

    context "with processor fraud" do
      let(:mock_status) { "fraud" }
      it "returns failure message" do
        expect(subject.response_errors).to_not be_empty
        expect(subject.response_errors.map(&:message).first).to eql "Gateway Rejected: fraud"
      end
    end

    context "with device_data" do
      let(:mock_status) { "success" }
      let(:options) do
        { merchant_id: "hello-labs-1",
          private_key: "hello-labs-ssh",
          public_key:  "hello-world",
          merchant_account_id: " ",
          environment: :sandbox,
          amount:      amount,
          token:       "test-101",
          mock_status: mock_status,
          device_data: "test" }
      end

      it "should send device data" do
        expect(Braintree::Transaction).to receive(:sale).with(
          amount: options[:amount],
          payment_method_token: options[:token], device_data: "test",
          options: { skip_advanced_fraud_checking: true }
        ).and_call_original
        expect(subject.transaction_status).to eql "authorized"
        expect(subject.error_type).to eql nil
      end
    end

    context "with fraud checking option" do
      let(:mock_status) { "success" }
      let(:options) do
        { merchant_id: "hello-labs-1",
          private_key: "hello-labs-ssh",
          public_key:  "hello-world",
          environment: :sandbox,
          amount:      amount,
          token:       "test-101",
          mock_status: mock_status,
          enable_fraud_checking: true }
      end

      it "does not skip fraud checking" do
        expect(Braintree::Transaction).to receive(:sale).with(
          amount: options[:amount],
          payment_method_token: options[:token],
          options: { skip_advanced_fraud_checking: false }
        ).and_call_original

        expect(subject.transaction_status).to eql "authorized"
      end
    end

    context "without a merchant_account_id" do
      let(:options) do
        { merchant_id: "hello-labs-1",
          private_key: "hello-labs-ssh",
          public_key:  "hello-world",
          merchant_account_id: " ",
          environment: :sandbox,
          amount:      amount,
          token:       "test-101",
          mock_status: mock_status }
      end
      let(:mock_status) { "success" }

      before do
        expect(Braintree::Transaction).to receive(:sale).with(
          amount: options[:amount],
          payment_method_token: options[:token],
          options: { skip_advanced_fraud_checking: true }
        ).and_call_original
      end

      its(:transaction_status) { should eql "authorized" }
    end
  end
end
