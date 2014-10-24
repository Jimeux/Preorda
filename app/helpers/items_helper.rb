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

  def print_item_description(item)
    return if item.description.blank?

    if is_in_music_dept?(item) && item.description.include?("1\t")
      lines = item.description.split("\n")
      tracks = lines.map do |l|
        parts = l.split("\t")
        { index: parts[0], name: parts[1]  }
      end
      tracks.map! do |track|
        "<tr><td>#{track[:index]}</td><td>#{track[:name]}</td></tr>"
      end

      raw "<table class=\"table table-striped table-condensed\"><tbody>#{tracks.join(' ')}</tbody></table>"
    else
      raw item.description.gsub("\n", '<br>') if item.description
    end
  end

end