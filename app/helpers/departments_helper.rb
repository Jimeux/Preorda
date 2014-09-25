module DepartmentsHelper

  def print_summary_title(item)
    link_to item.title.size > 16 ?
        item.title.first(13) + '…' :
        item.title, item_path(item)
  end

  def print_summary_creator(item)
    item.creator.size > 20 ?
      item.creator.first(17) + '…' :
      item.creator
  end

end
