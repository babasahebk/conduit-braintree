require "spec_helper"

describe Conduit::Driver::Braintree::Parser::Base do
  subject { described_class.new(response_body) }
  let(:response_body) { '{"foo":{"bar": "baz"}}' }

  describe "#json" do
    subject { described_class.new(response_body).json }
    it "should be the hash representation of the json string" do
      should be_a(Hash)
    end

    it "should have symbols for keys" do
      expect(subject.keys.all? { |key| key.is_a?(Symbol) }).to eql true
    end

    context "if the response is nil" do
      let(:response_body) { nil }
      it { should be_empty }
    end

    context "if the response is not a json object" do
      let(:response_body) { "NaN" }
      it { should_not be_empty }
      it "should have an error indicating that it could not be parsed" do
        instance = described_class.new(response_body)
        expect(instance.errors.map(&:message)).to include "Unable to parse response"
      end
    end
  end

  describe "#response_status" do
    context "when the response object has true stored at successful" do
      let(:response_body) { '{"successful":true,"foo":{"bar": "baz"}}' }
      its(:response_status) { should eql "success" }
    end

    context "when the response object has false stored at successful" do
      let(:response_body) { '{"successful":false,"foo":{"bar": "baz"}}' }
      its(:response_status) { should eql "failure" }
    end
  end

  describe "#errors" do
    context "when there is no errors key in the response" do
      its(:errors) { should be_empty }
    end

    context "when the errors key points to an empty array" do
      let(:response_body) { '{"errors":[],"foo":{"bar": "baz"}}' }
      its(:errors) { should be_empty }
    end

    context "when the errors key points to an array" do
      let(:response_body) { '{"errors":["You bad"],"foo":{"bar": "baz"}}' }
      its(:errors) { should_not be_empty }
      its(:errors) { should eql [Conduit::Error.new(message: "You bad")] }
    end
  end

  describe "#object_path" do
    subject { described_class.new(response_body).object_path(path) }

    context "when the path exists" do
      let(:path) { "foo/bar" }
      it "should return the object at the path location" do
        should eql "baz"
      end

      context "and points to an array element" do
        let(:response_body) { '{"foo":[{"bar":"baz"},{"bar":"quux"}]}' }
        let(:path)          { "foo/0/bar" }
        it "should zero-based index the array to find the object" do
          should eql "baz"
        end
      end
    end

    context "when the path does not exist" do
      let(:path) { "not/there" }
      it "should return nil" do
        should be_nil
      end
    end
  end
end
