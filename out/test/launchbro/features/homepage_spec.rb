require 'rails_helper'

feature 'Item listings' do

  context 'Search test' do

    let(:home_page) { HomePage.new }

    before do
      home_page.load
    end

    scenario 'a user visits to check out releases' do
      dept_names = Department.all.map { |d| t("dept.#{d.name}") }
      dept_names.each do |name|
        expect(home_page).to have_content t('dept.index.coming_soon', dept: name)
      end
    end

    scenario 'a search term is entered' do
      query = 'query'
      home_page.search_for(query)
      expect(home_page.search_field.value).to eq(query)
    end

  end
end

