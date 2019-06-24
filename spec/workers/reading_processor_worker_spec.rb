require "rails_helper"
RSpec.describe  ReadingProcessorWorker do
  describe "Reading Processor Workers" do
    it "Enqueues a reading processor worker" do
      ReadingProcessorWorker.perform_async(1, 1)
      expect(ReadingProcessorWorker.jobs.size).to eq(1)
      expect(ReadingProcessorWorker).to be_retryable 2
    end
  end
end