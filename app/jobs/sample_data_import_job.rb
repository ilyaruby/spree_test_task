class SampleDataImportJob < ApplicationJob
  queue_as :default

  def perform(sample_file_name)
    sample_data = SampleData.new(File.open(sample_file_name, 'r'))
    SampleDataImporter.import(sample_data)
  end
end
