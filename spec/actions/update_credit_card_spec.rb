require 'spec_helper'
require 'braintree'
require 'conduit/braintree'

describe Conduit::Driver::Braintree::CreateCreditCard do
  subject do
    described_class.new(options).perform.parser
  end

  let(:options) do
    { merchant_id:      'hello-labs-1',
      private_key:      'hello-labs-ssh',
      public_key:       'hello-world',
      environment:      :sandbox,
      mock_status:      mock_status,
      token:            '24sss2',
      customer_id:      'k4rs72_1',
      cardholder_name:  'John Doe',
      number:           '4111111111111111',
      cvv:              '',
      expiration_month: 12,
      expiration_year:  2099,
      billing_address:  {}
    }
  end

  let(:amount) { 10 }

  describe '#perform' do
    context 'with a successful authorization' do
      let(:mock_status)       { 'success' }
      its(:response_status)   { should eql mock_status }
      its(:cardholder_name)   { should eql options[:cardholder_name] }
      its(:expiration_month)  { should eql options[:expiration_month].to_s }
      its(:expiration_year)   { should eql options[:expiration_year].to_s }
      its(:token)             { should eql options[:token] }
      its(:card_type)         { should eql 'Visa' }
      its(:bin)               { should eql '411111' }
      its(:last_four)         { should eql '1111' }
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
