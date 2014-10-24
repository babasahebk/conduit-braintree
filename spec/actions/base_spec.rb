require 'spec_helper'

describe Conduit::Driver::Braintree::Base do
  it_should_behave_like 'a conduit-braintree action',
    { environment: :sandbox,
      merchant_id: '12345',
      public_key:  'something-you-can-see',
      private_key: 'something-secret' }
end
