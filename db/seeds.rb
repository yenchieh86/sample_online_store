ShippingInformation.delete_all
Order.delete_all
Item.delete_all
Category.delete_all
User.delete_all
StoreActivity.delete_all

admin_1 = User.new(username: ENV["ADMIN_1_USERNAME"], email: ENV["ADMIN_1_EMAIL"], password: ENV["ADMIN_1_PASSWORD"],
                   password_confirmation: ENV["ADMIN_1_PASSWORD"], role: 'admin')
admin_1.skip_confirmation!
admin_1.save

admin_2 = User.new(username: ENV["ADMIN_2_USERNAME"], email: ENV["ADMIN_2_EMAIL"], password: ENV["ADMIN_2_PASSWORD"],
                   password_confirmation: ENV["ADMIN_2_PASSWORD"], role: 'admin')
admin_2.skip_confirmation!
admin_2.save

backup_user = User.new(username: ENV["BACKUP_USERNAME"], email: ENV["BACKUP_EMAIL"], password: ENV["BACKUP_PASSWORD"],
                   password_confirmation: ENV["BACKUP_PASSWORD"], role: 'admin')
backup_user.skip_confirmation!
backup_user.save

10.times do |n|
  u = User.new(username: "testuser#{n}", email: "user#{n}@test.com", password: '111111',
               password_confirmation: '111111')
  u.skip_confirmation!
  u.save
end

10.times do |n|
  category = Category.create(title: "Categoryn#{n}", description: "CategorynDescription#{n}")
  10.times do |i|
    Item.create(title: "#{admin_1.username}#{category.title}Item#{i}", description: "ItemDescription#{i}", price: Faker::Number.decimal(2),
                stock: Faker::Number.between(0, 15), weight: Faker::Number.decimal(2), length: Faker::Number.decimal(2),
                width: Faker::Number.decimal(2), height: Faker::Number.decimal(2), user_id: admin_1.id,
                category_id: category.reload.id, sold: 0, shipping: Faker::Number.decimal(2))
  end
  10.times do |i|
    Item.create(title: "#{admin_2.username}#{category.title}Item#{i}", description: "ItemDescription#{i}", price: Faker::Number.decimal(2),
                stock: Faker::Number.between(0, 15), weight: Faker::Number.decimal(2), length: Faker::Number.decimal(2),
                width: Faker::Number.decimal(2), height: Faker::Number.decimal(2), user_id: admin_2.id,
                category_id: category.reload.id, sold: 0, shipping: Faker::Number.decimal(2))
  end
end



puts("Created #{User.count} users")
puts("Created #{Category.count} categories")
puts("Created #{Item.count} items")