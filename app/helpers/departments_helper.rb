module DepartmentsHelper

  def print_summary_title(item)
    link_to item.title.size > 16 ?
        item.title.first(13) + '…' :
        item.title, item_path(item)
  end

end
