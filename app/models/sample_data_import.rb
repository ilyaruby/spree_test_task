class SampleDataImport
  include ActiveModel::Model

  def persisted?
    false
  end

  class << self
    def import(sample_data)
      sample_data.each do |sample_item|
        import_item(sample_item)
      end
    end

    private

    def import_item(item)
      return unless item['name']

      product = create_product(item)
      product.save!

      associate_product_with_category(product, item)
      update_stock_item(product, item)
    end

    def associate_product_with_category(product, item)
      category = create_category(item)
      product.taxons << category
    end

    def create_product(item)
      Spree::Product.new name: item['name'],
                         description: item['description'],
                         price: item['price'],
                         shipping_category: default_shipping,
                         available_on: item['availability_date'],
                         slug: item['slug']
    end

    def find_or_create_variant(product)
      Spree::Variant.find_or_create_variant(is_master: false,
                                            product: product).save!
    end

    def update_stock_item(product, item)
      variant = Spree::Variant.find_by(product_id: product.id)
      stock_item = Spree::StockItem.find_or_create_by(variant_id: variant.id,
                                                      stock_location: default_stock_location)
      stock_item.count_on_hand = item['stock_total']
      stock_item.save!
    end

    def create_category(item)
      find_or_create_category(item['category'])
    end

    def categories_taxonomy
      Spree::Taxonomy.find_by(name: 'Categories') ||
        Spree::Taxonomy.create(name: 'Categories')
    end

    def find_or_create_category(name)
      Spree::Taxon.find_by(name: name) ||
        Spree::Taxon.create(name: name, taxonomy: categories_taxonomy)
    end

    def default_shipping
      Spree::ShippingCategory.find_or_create_by(name: 'Default')
    end

    def default_stock_location
      Spree::StockLocation.find_or_create_by(name: 'default')
    end
  end
end
