class SampleDataImporter
  def self.import(sample_data)
    sample_data.each do |sample_item|
      import_item(sample_item)
    end
  end

  private

  def self.import_item(item)
    return if item["name"].empty?

    product = create_product(item)
    associate_product_with_category(product, item)
    create_variant(product)

    product.save
  end

  def self.associate_product_with_category(product, item)
    category = create_category(product, item)
    product.taxons << category
  end

  def self.create_product(item)
    product = Spree::Product.new name: item["name"],
                                 description: item["description"],
                                 price: item["price"],
                                 shipping_category: default_shipping,
                                 available_on: item["availability_date"],
                                 slug: item["slug"]
  end

  def self.create_variant(product)
    Spree::Variant.create is_master: false, product: product
  end

  def self.create_category(product, item)
    category = find_or_create_category(item['category'])
  end
  
  def self.categories_taxonomy
    Spree::Taxonomy.find_by(name: "Categories") ||
      Spree::Taxonomy.create(name: "Categories")
  end

  def self.find_or_create_category(name)
    Spree::Taxon.find_by(name: name) ||
      Spree::Taxon.create(name: name, taxonomy: categories_taxonomy) 
  end

  def self.default_shipping
    Spree::ShippingCategory.find_by(name: "Default")
  end
end
