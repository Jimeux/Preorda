shared_context 'items loaded' do
  before(:each) do
    %w(video music games).each { |d| create_item_in(d) }

    #FactoryGirl.create(:custom_product, :name => 'Apache Baseball Jersey', :price => '19.99', :taxons => [apache_taxon, clothing_taxon])
  end

  def create_item_in(dept_name)
    dept = Department.find_by(name: dept_name)
    item = FactoryGirl.create(:item, department_id: dept.id)
    FactoryGirl.create(:product, item_id: item.id)
  end
end