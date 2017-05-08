# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.delete_all
Category.delete_all

admin_1 = User.new(username: ENV["ADMIN_1_USERNAME"], email: ENV["ADMIN_1_EMAIL"], password: ENV["ADMIN_1_PASSWORD"],
                   password_confirmation: ENV["ADMIN_1_PASSWORD"], role: 'admin')
admin_1.skip_confirmation!
admin_1.save

admin_2 = User.new(username: ENV["ADMIN_2_USERNAME"], email: ENV["ADMIN_2_EMAIL"], password: ENV["ADMIN_2_PASSWORD"],
                   password_confirmation: ENV["ADMIN_2_PASSWORD"], role: 'admin')
admin_2.skip_confirmation!
admin_2.save

10.times do |n|
  u = User.new(username: "testuser#{n}", email: "user#{n}@test.com", password: '111111',
               password_confirmation: '111111')
  u.skip_confirmation!
  u.save
end

10.times do |n|
  Category.create(title: "Categoryn#{n}", description: "Description#{n}")
end

puts("Created #{User.count} users")
puts("Created #{Category.count} categories")