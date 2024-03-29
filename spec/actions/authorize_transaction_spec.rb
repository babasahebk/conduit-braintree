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
      transaction_source: "recurring",
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

      it "request should contain transaction_source" do
        expect(described_class.new(options).view).
          to eql "{\"PaymentMethodToken\":\"test-101\",\"Amount\":10,\"TransactionSource\":\"recurring\"}\n"
      end
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
        expect(subject.json[:additional_processor_response]).to eql "2002 : Limit Exceeded"
        expect(subject.json[:processor_response_type]).to eql "hard_declined"
      end
    end

    context "with a processor failure" do
      let(:mock_status) { "gateway_failure" }
      it "returns a failure message" do
        expect(subject.message).to eql "Gateway Rejected: fraud (2004)"
        expect(subject.error_type).to eql "hard"
        expect(subject.json[:additional_processor_response]).
          to eql "Additional Processor Response: 63 : SERV NOT ALLOWED"
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
          device_data: "test",
          transaction_source: "recurring" }
      end

      it "should send device data" do
        expect(Braintree::Transaction).to receive(:sale).with(
          amount: options[:amount],
          payment_method_token: options[:token], device_data: "test",
          transaction_source: "recurring",
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

    context "when a timeout exception occurs" do
      let(:mock_status) { "success" }

      it "should handle exception" do
        expect(Braintree::Transaction).to receive(:sale).and_raise(Net::ReadTimeout)
        expect(subject.response_errors.map(&:message).first).to eql "Braintree timeout (error)"
      end
    end
  end
end
