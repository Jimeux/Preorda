require 'rails_helper'

describe 'The Homepage' do

  let(:home_page) { HomePage.new }
  before          { home_page.load }

  it 'displays a summary of releases in departments' do
    dept_names = Department.all.map do |dept|
      t("dept.#{dept.name}")
    end

    dept_names.each do |name|
      expect(home_page).to have_content
        t('dept.index.coming_soon', dept: name)
    end
  end

  context 'when a search is submitted' do
    it 'keeps the query in the textfield' do
      query = 'query'
      home_page.search_for(query)
      expect(home_page.search_field.value).to eq(query)
    end
  end

end