require 'rails_helper'

RSpec.feature "ProductDetails", type: :feature, js: true do  #TODO
  
  # SETUP
  before :each do
    @category = Category.create! name: 'Apparel'

    10.times do |n|
      @category.products.create!(
        name:  Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end
  
  scenario "When product image is clicked, show product details" do
    visit root_path
    first('.product > header').click
    save_screenshot 'product_details.png'
    # puts page.html
    expect(page).to have_css 'section.products-show'
  end

end
