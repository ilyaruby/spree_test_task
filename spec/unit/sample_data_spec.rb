#:encoding: utf-8
require File.expand_path(File.join(File.dirname(__FILE__), '../rails_helper'))

describe 'SampleData' do
  let(:sample_file_contents) do
    <<~SAMPLE_FILE
      ;name;description;price;availability_date;slug;stock_total;category
      ;Ruby on Rails Bag;Animi officia aut amet molestiae atque excepturi. Placeat est cum occaecati molestiae quia. Ut soluta ipsum doloremque perferendis eligendi voluptas voluptatum.;22,99;2017-12-04T14:55:22.913Z;ruby-on-rails-bag;15;Bags
      ;Spree Bag;Rerum quaerat autem non nihil quo laborum aut hic. Iure adipisci neque eum qui dolor. Velit sed molestias nostrum et dolore. Amet sed repellendus quod et ad.;25,99;2017-12-04T14:55:22.913Z;spree-bag;5;Bags
      ;Spree Tote;Consequuntur quibusdam repellendus quia non. Iste et pariatur nulla fugit. In ipsum accusantium quasi mollitia et eos. Ullam veniam quis ut adipisci est autem molestiae eos. Ab necessitatibus et rerum quasi quia debitis eum.;14,99;2017-12-30T14:55:22.913Z;spree-tote;20;Bags
    SAMPLE_FILE
  end
  let(:sample_keys) { ["name", "description", "price", "availability_date", "slug", "stock_total", "category"] }
  let(:sample_file_name) { 'sample.csv' }

  context 'csv data parsing' do
    let(:sample_data) { SampleData.new(StringIO.new(sample_file_contents)) }
    let(:sample_item) { sample_data.first }

    it 'will parse sample data' do
      expect(sample_data.size).to eq 3
    end

    it 'will load sample items' do
      expect(sample_item.class).to eq SampleItem
    end

    it 'will parse a correct header' do
      expect(sample_item.keys).to eq sample_keys
    end
  end
end
