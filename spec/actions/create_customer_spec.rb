require "spec_helper"

describe Conduit::Driver::Braintree::CreateCustomer do
  subject do
    described_class.new(options).perform.parser
  end

  let(:options) do
    { merchant_id:      "hello-labs-1",
      private_key:      "hello-labs-ssh",
      public_key:       "hello-world",
      environment:      :sandbox,
      mock_status:      mock_status,
      customer_id:      "f2b5gb_1",
      first_name:       "test",
      last_name:        "tester" }
  end

  let(:amount) { 10 }

  describe "#perform" do
    context "with a successful authorization" do
      let(:mock_status)       { "success" }
      its(:response_status)   { should eql mock_status }

      context "when customer id is provided" do
        its(:customer_id) { should eql options[:customer_id] }
      end

      context "when customer id is not provided" do
        its(:customer_id) { should_not be_empty }
      end
    end

    context "with extra options" do
      let(:options) do
        { merchant_id:      "hello-labs-1",
          private_key:      "hello-labs-ssh",
          public_key:       "hello-world",
          environment:      :sandbox,
          mock_status:      "success",
          customer_id:      "f2b5gb_1",
          first_name:       "test",
          last_name:        "tester",
          archived:         false }
      end

      it "only passes defined attributes" do
        expect(Braintree::Customer).to receive(:create).with(
          hash_including(
            first_name:       "test",
            last_name:        "tester",
            id:               "f2b5gb_1"
          )
        ).and_call_original
        described_class.new(options).perform
      end
    end

    context "with device_data" do
      let(:mock_status) { "success" }
      let(:options) do
        { merchant_id:      "hello-labs-1",
          private_key:      "hello-labs-ssh",
          public_key:       "hello-world",
          environment:      :sandbox,
          mock_status:      mock_status,
          customer_id:      "f2b5gb_1",
          device_data:      "test" }
      end

      it "should send device data" do
        expect(Braintree::Customer).to receive(:create).with(device_data: "test", id: "f2b5gb_1").and_call_original
        expect(subject.customer_id).to eql options[:customer_id]
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
  end
end
