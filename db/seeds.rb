# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Space.destroy_all

descriptions = ["Photo", "Danse", "Peinture", "Musique", "Sculpture", "Poterie"]

cities = ["Paris", "Lyon", "Marseille", "Toulouse", "Lille", "Strasbourg", "Grenoble", "Nice", "Rennes", "Brest", "Bordeaux", "Biarritz", "Montpellier", "Nantes", "Clermont-Ferrant", "Caen", "Limoges", "Auxerre", "Dijon", "Tours", "Chartres"]

20.times do
  User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    password: Faker::Internet.password(min_length: 6),
    email: Faker::Internet.email,
  )
end

20.times do
  Space.create(
    host_id: User.all.sample.id,
    city: cities.sample,
    description: descriptions.sample,
  )
end

200.times do
  space = Space.all.sample
  Booking.create(
    guest_id: User.where.not(id: space.host_id).sample.id,
    space: space,
    duration: [30, 60, 90, 120, 180].sample,
    start_date: Time.now,
  )
end