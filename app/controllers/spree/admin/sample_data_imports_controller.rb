require 'fileutils'

module Spree
  class Admin::SampleDataImportsController < Admin::BaseController
    def show
      @sample_data_import = SampleDataImport.new
    end

    def create
      uploaded_tempfile = params[:file].path
      basename = File.basename(uploaded_tempfile)
      persistent_filename = Rails.root.join('tmp', 'sample_data_import_files', basename).to_s
      FileUtils.cp uploaded_tempfile, persistent_filename
      SampleDataImportJob.perform_later persistent_filename
      flash[:notice] = t('sample_data_queued')
      redirect_to admin_products_path
    end

    def import
    end
  end
end
