# This project uses seeds in development only.
# BEWARE! It runs destroy_all on all models first!
# Run with rails db:seed

unless Rails.env.development?
  puts "[ db/seeds.rb ] Seed data is for development only, " +
    "not #{Rails.env}"
  exit 0
end

require "factory_bot"

User.destroy_all
Webpage.destroy_all

puts "[ db/seeds.rb ] Creating development data..."

admin = FactoryBot.create(:user, :as_admin,
  username: "admin", email: "admin@test.com", password: "asdf1234")
5.times do
  FactoryBot.create(:user)
end

FactoryBot.create(:webpage, user: admin)
FactoryBot.create(:webpage,
  title: "Lobste.rs", url: "lobste.rs", user: admin)
FactoryBot.create(:webpage,
  title: "MEM Site", url: "mem.cool", user: admin)

puts "[ db/seeds.rb ] Done"
