class SampleItem
  def initialize(header, row)
    @data = {}
    header.each_with_index { |key, i| @data[key] = row[i] }
  end

  def method_missing(m, *args, &block)
    @data.send(m, *args, &block)
  end

  def respond_to?(method_name, include_private = false)
    @data.include?(method_name.to_sym) || super
  end
end
