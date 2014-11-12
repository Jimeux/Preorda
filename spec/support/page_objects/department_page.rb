class DepartmentPage < SitePrism::Page
  #set_url Rails.application.routes.url_helpers.root_path
  set_url '/{dept_name}'

  #element :container, '.dept-container'
  element :js_platform_select,   '#platform-select-js'
  element :html_platform_select, '#platform-select-no-js'

  def method ; end
end