require 'rails_helper'

describe 'The Search Bar' do
  let(:home_page) { HomePage.new }
  let(:item)      { FactoryGirl.create(:product).item }
  before { home_page.load }

  context 'when exact title is queried' do
    it 'finds a match' do
      home_page.search_for(item.title)
      expect(home_page).to have_text(HomePage::ONE_RESULT)
      expect(home_page).to have_text(item.title)
    end
  end

  context 'when partial title is queried' do
    it 'finds a match' do
      [item.title[0..2], item.title[1..3]].each do |query|
        home_page.search_for(query)
        expect(home_page).to have_text(HomePage::ONE_RESULT)
        expect(home_page).to have_text(item.title)
      end
    end
  end

  context 'when query is empty' do
    it 'displays no results' do
      home_page.search_for('')
      expect(home_page).to have_text(HomePage::NO_RESULTS)
    end
  end

  context 'when query is less then 3 characters' do
    it 'displays no results' do
      [item.title.first(1), item.title.first(2)].each do |query|
        home_page.search_for(query)
        expect(home_page).to have_text(HomePage::NO_RESULTS)
      end
    end
  end

end