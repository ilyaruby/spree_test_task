require 'rails_helper'

describe 'SampleDataImport' do
  include ActiveJob::TestHelper

  context 'Admin uploads sample file and it is goes to queue' do
    it 'will enqueue job' do
      old = ActiveJob::Base.queue_adapter
      ActiveJob::Base.queue_adapter = :test

      admin = create(:admin_user, email: 'admin@example.com')

      # sign in
      visit '/login'
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: 'secret'
      click_button 'Login'

      visit spree.admin_path
      expect(page).not_to have_content('Submit sample data')

      # expand tab
      expect(page).to have_content 'Sample Data Imports'
      click_link 'Sample Data Imports'
      expect(page).to have_content('Submit sample data')
      expect(page).to have_selector('input[type=submit][value="Import"]')

      # Upload
      expect(SampleDataImportJob).not_to(
        have_been_enqueued
      )

      attach_file('file', File.absolute_path('./sample.csv'))
      click_button 'Import'

      expect(SampleDataImportJob).to(
        have_been_enqueued
      )

      ActiveJob::Base.queue_adapter = old
    end
  end
  context 'Admin uploads sample file and it will eventually add new products' do
    it 'should actually add products' do
      admin = create(:admin_user, email: 'admin@example.com')

      # sign in
      visit '/login'
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: 'secret'
      click_button 'Login'

      visit spree.admin_path
      expect(page).not_to have_content('Submit sample data')

      # expand tab
      expect(page).to have_content('Sample Data Imports')
      click_link 'Sample Data Imports'
      expect(page).to have_content('Submit sample data')
      expect(page).to have_selector("input[type=submit][value='Import']")

      expect(Spree::Product.count).to be_zero

      perform_enqueued_jobs do
        attach_file('file', File.absolute_path('./sample.csv'))
        click_button 'Import'
      end

      expect(Spree::Product.count).not_to be_zero
    end

    after do
      clear_enqueued_jobs
      clear_performed_jobs
    end
  end
end
