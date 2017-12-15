require 'rails_helper'

RSpec.describe SampleDataImportJob, type: :job do
	include ActiveJob::TestHelper

  let(:job) { SampleDataImportJob.perform_later("sample.csv") }
  it "matches with enqueued job" do
		old = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :test

    job
    expect(SampleDataImportJob).to(
      have_been_enqueued.with("sample.csv")
    )

		ActiveJob::Base.queue_adapter = old
  end

  context "actualy perform an import job" do
    include_context "shared_sample_data"

    it "will actualy imports sample data" do
      allow(File).to receive(:open).with(any_args).and_call_original
      allow(File).to receive(:open).with('sample.csv', 'r') { sample_file_io }

      expect(Spree::Product.count).to eq 0
			perform_enqueued_jobs { job }
      expect(Spree::Product.count).not_to eq 0

      RSpec::Mocks.space.proxy_for(File).reset
    end

		after do
			clear_enqueued_jobs
			clear_performed_jobs
		end
  end
end
