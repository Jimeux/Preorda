require 'rails_helper'

describe 'The Show Item Page' do
  let(:show_item_page) { ShowItemPage.new }

  context 'when item has no platform' do
    it 'prints nothing without error' do
      item = FactoryGirl.create(:item, platform_id: nil)
      show_item_page.load(id: item.id)
      expect(show_item_page.platform.text).to be_empty
    end
  end

end