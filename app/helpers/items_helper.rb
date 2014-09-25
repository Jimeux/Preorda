module ItemsHelper

  def print_time_to_release(item)
    if item.release_date
      "#{distance_of_time_in_words_to_now(
          item.release_date).gsub('about', '')} left"
    else
      'TBC'
    end
  end

  def btn_class(item)           #TODO: Remove this abomination
    case item.department.name
      when 'Games' then return 'danger'
      when 'Music' then return 'primary'
      when 'Video' then return 'success'
    end
  end

  def is_on_music_dept?(item)
    item.department.name == 'Music'
  end

end