require_relative '../../utils/app_logger.rb'

describe AppLogger do
  subject(:app_logger) { described_class.instance }

  describe '#log' do
    let(:message_type) { :info }
    let(:message) { 'This is a test message' }
    let(:logger) { instance_double(Logger) }

    before do
      allow(app_logger).to receive(:logger).and_return(logger)
    end

    it 'sends the log message to the logger with the given message type' do
      expect(logger).to receive(:send).with(message_type, message)

      app_logger.log(message_type: message_type, message: message)
    end
  end

  describe 'singleton behavior' do
    it 'returns the same instance' do
      instance1 = described_class.instance
      instance2 = described_class.instance

      expect(instance1).to be(instance2)
    end
  end
end
