module ItemsHelper

  # TODO: Update for products that have already been released
  def print_time_to_release(item)
    if item.release_date.blank?
      t('item.release.tbc')
    elsif item.release_date == Date.today
      t('item.release.today')
    elsif item.release_date.past?
      t('item.release.past')
    elsif item.release_date.future?
      time_from_now = distance_of_time_in_words_to_now(
          item.release_date).gsub('about', '')
      t('item.release.future', time_left: time_from_now)
    end
  end

  def is_in_music_dept?(item)
    item.department.name == 'music'
  end

end