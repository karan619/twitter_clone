# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

pas = "password"
User.create!( name: "Administrator",	email: "admin@twitter.com",	password: pas,	password_confirmation: pas, admin: true,  activated: true, activated_at: Time.zone.now )

99.times do |n|
	name = Faker::Name.name
	email = "test#{n}@example.com"
	User.create!( name: name,	email: email,	password: pas,	password_confirmation: pas, activated: true, activated_at: Time.zone.now )
end

users = User.order(:created_at).take(6)
50.times do
	content = Faker::Lorem.sentence(5)
	users.each{ |user| user.microposts.create!(content: content) }
end
