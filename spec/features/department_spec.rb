require 'rails_helper'

describe 'Department pages' do
  let(:dept_page)  { DepartmentPage.new }
  let(:department) { Department.first }
  before           { dept_page.load(dept_name: department.name) }

  it 'displays a "coming soon" title' do
    expect(dept_page).to have_content(
      t('dept.index.coming_soon', dept: t("dept.#{department.name}")))
  end

  it 'lists all platforms in a select box' do
    department.platforms.each do |platform|
      expect(dept_page.js_platform_select)
          .to have_content(platform.name)
      expect(dept_page.html_platform_select)
          .to have_content(platform.name)
    end
  end

  context 'when items have been created' do
    include_context 'items loaded'
    before { dept_page.load(dept_name: department.name) }

    it 'displays only items from this department' do
      dept_items = Item.where(department_id: department.id)
      dept_items.each do |item|
        expect(dept_page).to have_content item.title
      end

      non_dept_items = Item.where.not(department_id: department.id)
      non_dept_items.each do |item|
        expect(dept_page).not_to have_content item.title
      end
    end
  end

end