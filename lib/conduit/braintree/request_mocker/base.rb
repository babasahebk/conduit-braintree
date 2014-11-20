require 'erb'
require 'tilt'
require 'webmock'
require 'zlib'

module Conduit::Braintree::RequestMocker
  class Base
    include WebMock::API

    FIXTURE_PREFIX = "#{File.dirname(__FILE__)}/../../../../spec/fixtures".freeze

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
      response = Tilt::ERBTemplate.new(fixture).render(@base.view_context)
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
