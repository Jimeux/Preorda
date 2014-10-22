class HomePage < SitePrism::Page
  #set_url Rails.application.routes.url_helpers.root_path
  set_url '/'

  element  :brand_link,    'a.navbar-brand'
  element  :search_field,  'input#q'
  element  :search_button, 'button#search-button'

  NO_RESULTS = I18n.t('will_paginate.page_entries_info.single_page_html.zero')
  ONE_RESULT = I18n.t('will_paginate.page_entries_info.single_page_html.one')

  def search_for(query)
    search_field.set(query)
    search_button.click
  end
end