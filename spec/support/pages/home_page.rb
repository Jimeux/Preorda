class HomePage < SitePrism::Page
  #set_url Rails.application.routes.url_helpers.root_path
  set_url '/'

  element  :search_field,  'input#q'
  element  :search_button, 'button#search-button'

  def search_for(query)
    search_field.set(query)
    search_button.click
  end
end