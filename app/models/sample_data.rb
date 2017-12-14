require 'csv'

class SampleData
  def initialize(sample_file_io)
    @data = parse_sample_io(sample_file_io).force
  end

  def method_missing(m, *args, &block)
    @data.send(m, *args, &block)
  end

  def respond_to?(method_name, include_private = false)
    @data.include?(method_name.to_sym) || super
  end

  private

  def parse_sample_io(sample_file_io)
    csv = CSV.new(sample_file_io, headers: true, col_sep: ';').lazy
    csv.map do |row|
      SampleItem.new(row.headers.drop(1), row.fields.drop(1))
    end
  end
end
