#:encoding: utf-8
require File.expand_path(File.join(File.dirname(__FILE__), '../rails_helper'))

describe 'SampleDataImport' do
  include_context 'shared_sample_data'

  def categories_taxonomy
    Spree::Taxonomy.find_by(name: "Categories")
  end

  def bags_taxon
    Spree::Taxon.find_by(name: "Bags")
  end

  let(:imported_product) { Spree::Product.first }
  
  it "imports sample items" do
    expect(Spree::Product.count).to eq 0
    SampleDataImport.import(sample_data)
    expect(Spree::Product.count).not_to eq 0
  end

  it "creates a Categories taxonomy if it does not exists yet" do
    expect(categories_taxonomy).to be_nil
    SampleDataImport.import(sample_data)
    expect(categories_taxonomy).not_to be_nil
  end

  it "creates a Bags taxon if it does not exists yet" do
    expect(bags_taxon).to be_nil
    SampleDataImport.import(sample_data)
    expect(bags_taxon).not_to be_nil
  end

  it "creates a master variant for an imported product" do
    expect(Spree::Variant.count).to eq 0
    SampleDataImport.import(sample_data)
    expect(Spree::Variant.count).not_to eq 0
  end

  it "fills in price" do
    SampleDataImport.import(sample_data)
    expect(imported_product).not_to be_nil
  end

  it "creates StockItem for an imported product" do
    expect(Spree::StockItem.count).to eq 0
    SampleDataImport.import(sample_data)
    expect(Spree::StockItem.count).not_to eq 0
  end

  it "fills in count_on_hand to StockItem" do
    SampleDataImport.import(sample_data)
    variant = Spree::Variant.find_by(product_id: imported_product.id)
    stock_item = Spree::StockItem.find_by(variant_id: variant.id)
    expect(stock_item.count_on_hand).not_to be_zero
    expect(stock_item.count_on_hand).not_to be_nil
  end
end
