request_mockers = File.join(File.dirname(__FILE__), "request_mocker", "*.rb")
Dir.glob(request_mockers) { |fname| require fname }
