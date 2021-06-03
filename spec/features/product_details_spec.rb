require 'rails_helper'

RSpec.feature "ProductDetails", type: :feature, js: true do
  
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
  
  scenario "When product image or name is clicked, show product details" do
    visit root_path
    first('.product > header').click     #ambiguity resolution
    save_screenshot 'product_details.png'
    # puts page.html
    expect(page).to have_css 'section.products-show', count: 1
  end

  scenario "When product Details button is clicked, show product details" do
    visit root_path
    find_link("Details »", href: product_path(Product.first.id)).click
    save_screenshot 'product_details2.png'
    expect(page).to have_text(Product.first.name).and have_css "article.product-detail", count: 1
  end

end


#click_link("Details", match: :first)
#first('article.product').click
