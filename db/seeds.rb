# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

pas = "password"
User.create!( name: "Administrator",	email: "admin@twitter.com",	password: pas,	password_confirmation: pas, admin: true )

99.times do |n|
	name = Faker::Name.name
	email = "test#{n}@example.com"
	User.create!( name: name,	email: email,	password: pas,	password_confirmation: pas )
end