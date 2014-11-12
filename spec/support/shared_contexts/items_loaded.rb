shared_context 'items loaded' do
  before(:each) do
    %w(video music games).each { |d| create_item_in(d) }
  end

  def create_item_in(dept_name)
    dept = Department.find_by(name: dept_name)
    item = FactoryGirl.create(:item, department_id: dept.id)
    FactoryGirl.create(:product, item_id: item.id)
  end
end