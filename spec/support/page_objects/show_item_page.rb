class ShowItemPage < SitePrism::Page
  #set_url Rails.application.routes.url_helpers.items_path
  set_url '/preorders{/id}'

  element  :platform, '.item-platform'

end