# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

default_categories = %w(default)

default_categories.each do |value|
  Category.create name: value
end

disabled_user = %w(signup signin signout account accounts password passwords picture pictures article articles
                   category categories comment comments aboutme drafts archive search resume activation activations
                   setting settings application routes namespace community communities)

disabled_user.each do |username|
  password = SecureRandom.hex(12)
  User.create username: username, email: "#{username}@hijinhu.me", 
              password: password, password_confirmation: password,
              state: 0
end