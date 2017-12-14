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
    product.save

    associate_product_with_category(product, item)
    update_stock_item(product, item)
  end

  def self.associate_product_with_category(product, item)
    category = create_category(product, item)
    product.taxons << category
  end

  def self.create_product(item)
    Spree::Product.new name: item["name"],
                       description: item["description"],
                       price: item["price"],
                       shipping_category: default_shipping,
                       available_on: item["availability_date"],
                       slug: item["slug"]
  end

  def self.find_or_create_variant(product)
    Spree::Variant.find_or_create_variant(is_master: false, product: product).save!
  end

  def self.update_stock_item(product, item)
    variant = Spree::Variant.find_by(product_id: product.id)
    stock_item = variant.stock_items.first
    stock_item.count_on_hand = item["stock_total"]
    stock_item.save!
  end

  def self.create_category(product, item)
    find_or_create_category(item['category'])
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
