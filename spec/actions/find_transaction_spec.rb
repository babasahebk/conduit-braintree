require 'spec_helper'
require 'braintree'
require 'conduit/braintree'

describe Conduit::Driver::Braintree::FindTransaction do

  subject do
    described_class.new(options).perform.parser
  end

  let(:options) do
    { merchant_id:      'hello-labs-1',
      private_key:      'hello-labs-ssh',
      public_key:       'hello-world',
      environment:      :sandbox,
      reference_number: 'k4rs72',
      mock_status:      mock_status
    }
  end

  describe '#perform' do
    context 'with a successful authorization' do
      let(:mock_status)        { 'success' }
      its(:response_status)    { should eql mock_status }
    end
  end
end
