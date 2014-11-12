require 'rails_helper'

describe Item do

  let(:item) { FactoryGirl.create(:item, department_id: Department.first) }

  before do
    Store.all.each do |store|
      FactoryGirl.create(:product, item_id: item.id, store_id: store.id)
    end
  end

  subject { item }

  it { should respond_to :department }
  it { should respond_to :platform   }
  it { should respond_to :products   }
  it { should respond_to :image      }

  it 'retrieves the lowest priced product' do
    expect(item.lowest_price)
        .to eq(item.products.pluck(:price).min)
  end

  context 'when there are multiple products from a single store' do
    let(:store) { Store.first }

    before do
      FactoryGirl.create(:product, item_id: item.id, store_id: store.id)
    end

    it 'only returns one product from each store' do
      store_ids = item.list_products.map { |p| p.store_id }
      expect(store_ids.uniq.size).to eq store_ids.size
    end

    it 'returns the lowest priced product from each store' do
      lowest_price_in_store = Product.where(store_id: store.id, item_id: item.id)
                                     .order('price ASC').first.price
      store_entry = item.list_products.select { |p| p.store_id == store.id }.first
      expect(store_entry.price).to eq lowest_price_in_store
    end

  end

end