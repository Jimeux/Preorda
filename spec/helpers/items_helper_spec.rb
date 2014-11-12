require 'rails_helper'

describe ItemsHelper do

  let(:item) { FactoryGirl.create(:item) }

  describe '#print_time_to_release' do

    it 'returns a message for today\'s releases' do
      item.release_date = Date.today
      expect(helper.print_time_to_release(item))
        .to eq t('item.release.today')
    end

    it 'returns a message for past releases' do
      item.release_date = Date.yesterday
      expect(helper.print_time_to_release(item))
        .to eq t('item.release.past')
    end

    it 'returns a message for future releases' do
=begin
      item.release_date = Date.tomorrow
      time_left = distance_of_time_in_words_to_now(
          Date.tomorrow).gsub('about', '')          TODO: Try checking for number + 'left'
      expect(helper.print_time_to_release(item))
        .to eq t('item.release.future', time_left: time_left)
=end
    end

    it 'returns a message for TBC releases' do
      item.release_date = nil
      expect(helper.print_time_to_release(item))
        .to eq t('item.release.tbc')
    end

  end

end