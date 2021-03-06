module DepartmentsHelper

  def print_summary_title(item)
    link_to item.title.size > 16 ?
        item.title.first(13) + '…' :
        item.title, item_path(item)
  end

  def print_summary_creator(item)
    item.creator.size > 16 ?
      item.creator.first(13) + '…' :
      item.creator
  end

  def print_selected_platform(platform, dept)
    if platform.present?
      platform.name
    else
      dept.name == 'games' ?
          t('dept.show.select_platform') :
          t('dept.show.select_format')
    end
  end

  def thumb_height_for(department)
    case department.name
      when 'games' then return 105
      when 'video' then return 120
      when 'music' then return 85
      else return ''
    end
  end

end
