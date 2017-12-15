#:encoding: utf-8
require File.expand_path(File.join(File.dirname(__FILE__), '../rails_helper'))

describe 'SampleData' do
  include_context 'shared_sample_data'

  context 'csv data parsing' do
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
