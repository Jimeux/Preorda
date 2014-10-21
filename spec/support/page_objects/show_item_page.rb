class ShowItemPage < SitePrism::Page
  set_url '/items{/id}'

  element  :platform, '.item-platform'

end