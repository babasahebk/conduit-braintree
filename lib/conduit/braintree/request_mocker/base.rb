require 'erb'
require 'tilt'
require 'webmock'
require 'zlib'

module Conduit::Braintree::RequestMocker
  class Base
    include WebMock::API

    FIXTURE_PREFIX = "#{File.dirname(__FILE__)}/fixtures".freeze

    def initialize(base, options = nil)
      @base = base
      @options = options
      @mock_status = options[:mock_status].to_sym
    end

    def mock
      @stub = stub_request(:any, /braintree/).
        to_return(body: render_response, headers: {'Content-Encoding' => 'gzip'} )
    end

    def unmock
      remove_request_stub(@stub) if @stub
      @stub = nil
    end

    def with_mocking
      mock and yield.tap { unmock }
    end

    private

    def render_response
      response_mock = MockHelpers.new(@options)
      response = Tilt::ERBTemplate.new(fixture).
        render(@base.view_context, mock: response_mock)
      response.encode!('ASCII-8BIT')

      f = StringIO.new('')

      gz = Zlib::GzipWriter.new(f)
      gz.write(response)
      gz.finish

      f.string
    rescue
      nil
    end

    def action_name
      ActiveSupport::Inflector.demodulize(self.class.name).underscore
    end

    def fixture
      FIXTURE_PREFIX + "/#{action_name}/#{@mock_status}.xml.erb"
    end

    def response
      if [:success, :failure, :error].include?(@mock_status)
        return error_response if @mock_status == :error
        render_response
      else
        raise(ArgumentError, "Mock status must be :success, :failure, or :error")
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
