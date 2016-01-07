require 'erb'
require 'tilt'
require 'zlib'
require 'webmock'

module Conduit::Braintree::RequestMocker
  class Base

    FIXTURE_PREFIX = "#{File.dirname(__FILE__)}/fixtures".freeze

    def initialize(base, options = nil)
      @base = base
      @options = options
      @mock_status = options[:mock_status].to_sym
    end

    def mock
      @stub = set_webmock
    end

    def unmock
      @stub && WebMock.remove_request_stub(@stub)
    end

    def with_mocking
      mock
      yield
    ensure
      unmock
    end

    private

    def headers
      { 'Content-Encoding' => 'gzip' }
    end

    def set_webmock
      WebMock.stub_request(:any, /.*braintree.*/).to_return do |request|
        @status ||= case @mock_status
            when :error
              500
            when :failure
              response ? 422 : 404
            else
              200
            end
        {status: @status, headers: headers, body: response}
      end
    end

    def mocked_response
      response_mock = MockHelpers.new(@options)
      Tilt::ERBTemplate.new(fixture)
        .render(@base.view_context, mock: response_mock)
        .encode!('ASCII-8BIT')
    end

    def render_response
      f = StringIO.new('')

      gz = Zlib::GzipWriter.new(f)
      gz.write(mocked_response)

      f.string
    rescue
      nil
    ensure
      gz && gz.finish
    end

    def action_name
      ActiveSupport::Inflector.demodulize(self.class.name).underscore
    end

    def fixture
      FIXTURE_PREFIX + "/#{action_name}/#{@mock_status}.xml.erb"
    end

    def response
      if @mock_status
        return error_response if @mock_status == :error
        render_response
      else
        raise(ArgumentError, "Mock status must be set (:success, :failure, or :error for example)")
      end
    end

    def error_response
      '{"status": 500, "error": "Internal Service Error"}'
    end
  end
end

class MockHelpers
  TEST_CARD_NUMBER = '4111111111111111'

  def initialize(options = {})
    @options = options
  end

  def bin
    card_number[0, 6]
  end

  def last_4
    card_number[-4, 4]
  end

  private

  def card_number
    return TEST_CARD_NUMBER if number =~ /javascript/
    number
  end

  def number
    @number ||= @options[:number] || TEST_CARD_NUMBER
  end
end
