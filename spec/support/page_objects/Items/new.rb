require_relative '../pages/base'

module PageObjects
  module Items
    class New < Base
      
      def create(category,item)
        fill_form(:item, {category_id: category.title, title: item[:title], description: item[:description],
                          stock: item[:stock], price: item[:price], weight: item[:weight], length: item[:length], 
                          width: item[:width], height: item[:height]
        })
        click_button 'Save'
      end
      
    end
  end
end
