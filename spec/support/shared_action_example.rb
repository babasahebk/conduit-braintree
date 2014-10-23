require 'spec_helper'

shared_examples_for 'a conduit-braintree action' do |options|
  braintree_keys = Conduit::Driver::Braintree.credentials +
    Conduit::Driver::Braintree.required_attributes

  braintree_keys.each do |key|
    it "should configure the Braintree #{key}" do
      ::Braintree::Configuration.should_receive("#{key}=").with(options[key])
      described_class.new(options)
    end
  end
end
