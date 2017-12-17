require File.expand_path(File.join(File.dirname(__FILE__), '../rails_helper'))

describe 'SampleItem' do
  let(:header) { %w[name description price availability_date slug stock_total category] }
  let(:sample_item_name) { 'Bag Name' }
  let(:row) do
    [
      sample_item_name,
      'some nice description', # description
      '22,99', # price
      '2017-12-04T14:55:22.913Z', # available at
      'ruby-on-rails-bag', # slug
      '15', # stock_total
      'Bags'
    ]
  end
  let(:sample_item) { SampleItem.new header, row }

  it 'creates a correct SampleData with all relevant accessors' do
    expect(sample_item.keys).to eq header
    expect(sample_item.values).to eq row
    expect(sample_item['name']).to eq sample_item_name
    expect(sample_item.size).to eq header.size
  end
end
