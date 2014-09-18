module ItemsHelper

  def print_time_to_release(item)
    if item.release_date
      "#{distance_of_time_in_words_to_now(
          item.release_date).gsub('about', '')} left"
    else
      'TBC'
    end
  end

end