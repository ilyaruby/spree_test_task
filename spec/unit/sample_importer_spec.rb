#:encoding: utf-8
require File.expand_path(File.join(File.dirname(__FILE__), '../rails_helper'))

describe 'SampleImporter' do
  def categories_taxonomy
    Spree::Taxonomy.find_by(name: "Categories")
  end

  def bags_taxon
    Spree::Taxon.find_by(name: "Bags")
  end

  let(:sample_file_contents) do
    <<~SAMPLE_FILE
      ;name;description;price;availability_date;slug;stock_total;category
      ;Ruby on Rails Bag;Animi officia aut amet molestiae atque excepturi. Placeat est cum occaecati molestiae quia. Ut soluta ipsum doloremque perferendis eligendi voluptas voluptatum.;22,99;2017-12-04T14:55:22.913Z;ruby-on-rails-bag;15;Bags
      ;Spree Bag;Rerum quaerat autem non nihil quo laborum aut hic. Iure adipisci neque eum qui dolor. Velit sed molestias nostrum et dolore. Amet sed repellendus quod et ad.;25,99;2017-12-04T14:55:22.913Z;spree-bag;5;Bags
      ;Spree Tote;Consequuntur quibusdam repellendus quia non. Iste et pariatur nulla fugit. In ipsum accusantium quasi mollitia et eos. Ullam veniam quis ut adipisci est autem molestiae eos. Ab necessitatibus et rerum quasi quia debitis eum.;14,99;2017-12-30T14:55:22.913Z;spree-tote;20;Bags
    SAMPLE_FILE
  end
  let(:sample_data) { SampleData.new(StringIO.new(sample_file_contents)) }
  let(:imported_product) { Spree::Product.first }
  
  it "imports sample items" do
    expect(Spree::Product.count).to eq 0
    SampleDataImporter.import(sample_data)
    expect(Spree::Product.count).not_to eq 0
  end

  it "creates a Categories taxonomy if it does not exists yet" do
    expect(categories_taxonomy).to be_nil
    SampleDataImporter.import(sample_data)
    expect(categories_taxonomy).not_to be_nil
  end

  it "creates a Bags taxon if it does not exists yet" do
    expect(bags_taxon).to be_nil
    SampleDataImporter.import(sample_data)
    expect(bags_taxon).not_to be_nil
  end

  it "creates a master variant for imported product" do
    expect(Spree::Variant.count).to eq 0
    SampleDataImporter.import(sample_data)
    expect(Spree::Variant.count).not_to eq 0
  end

  it "fills in price" do
    SampleDataImporter.import(sample_data)

    expect(imported_product).not_to be_nil
  end
end
