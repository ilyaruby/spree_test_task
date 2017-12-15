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
    let(:sample_file_contents) do
      <<~SAMPLE_FILE
        ;name;description;price;availability_date;slug;stock_total;category
        ;Ruby on Rails Bag;Animi officia aut amet molestiae atque excepturi. Placeat est cum occaecati molestiae quia. Ut soluta ipsum doloremque perferendis eligendi voluptas voluptatum.;22,99;2017-12-04T14:55:22.913Z;ruby-on-rails-bag;15;Bags
        ;Spree Bag;Rerum quaerat autem non nihil quo laborum aut hic. Iure adipisci neque eum qui dolor. Velit sed molestias nostrum et dolore. Amet sed repellendus quod et ad.;25,99;2017-12-04T14:55:22.913Z;spree-bag;5;Bags
        ;Spree Tote;Consequuntur quibusdam repellendus quia non. Iste et pariatur nulla fugit. In ipsum accusantium quasi mollitia et eos. Ullam veniam quis ut adipisci est autem molestiae eos. Ab necessitatibus et rerum quasi quia debitis eum.;14,99;2017-12-30T14:55:22.913Z;spree-tote;20;Bags
      SAMPLE_FILE
    end
    let(:sample_file_io) { StringIO.new(sample_file_contents) }

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
