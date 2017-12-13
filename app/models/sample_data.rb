require 'csv'

class SampleData
  def initialize(sample_file_contents)
    @data = parse_sample_contents(sample_file_contents)
  end

  def method_missing(m, *args, &block)
    @data.send(m, *args, &block)
  end

  def respond_to?(method_name, include_private = false)
    @data.include?(method_name.to_sym) || super
  end

  private

  def parse_sample_contents(contents)
    parsed = CSV.parse(contents, col_sep: ?; )
    parsed.map! { |row| row[1..-1] } # get rid of first column which is empty

    header = parsed.first # first row is header
    parsed[1..-1].map do |row|
      SampleItem.new(header, row)
    end
  end
end
