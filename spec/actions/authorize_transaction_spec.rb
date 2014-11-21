require 'spec_helper'
require 'braintree'
require 'conduit/braintree'

describe Conduit::Driver::Braintree::AuthorizeTransaction do
  subject do
    described_class.new(options).perform.parser
  end

  let(:options) do
    { merchant_id: 'hello-labs-1',
      private_key: 'hello-labs-ssh',
      public_key:  'hello-world',
      environment: :sandbox,
      amount:      amount,
      token:       'test-101',
      mock_status: mock_status
    }
  end

  let(:amount) { 10 }

  describe '#perform' do
    context 'with a successful authorization' do
      let(:mock_status) { 'success' }
      its(:response_status)    { should eql mock_status }
      its(:transaction_status) { should eql 'authorized' }
      its(:transaction_amount) { should eql amount }
    end

    context 'with a failure authorizing' do
      let(:mock_status)        { 'failure' }
      its(:response_status)    { should eql mock_status }
      its(:errors) do
        should eql ["Invalid verification merchant account ID (917218)"]
      end
    end
  end
end