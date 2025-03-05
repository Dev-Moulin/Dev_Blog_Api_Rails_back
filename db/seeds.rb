# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Nettoyage de la base de données
puts "Nettoyage de la base de données..."
Article.destroy_all
User.destroy_all

# Création des utilisateurs
puts "Création des utilisateurs..."
users = []
5.times do |i|
  user = User.create!(
    email: "user#{i+1}@example.com",
    password: "password123",
    password_confirmation: "password123"
  )
  users << user
  puts "Utilisateur créé : #{user.email}"
end

# Création des articles
puts "Création des articles..."
30.times do |i|
  article = Article.create!(
    title: "Article #{i+1}",
    content: "Contenu de l'article #{i+1}. #{Faker::Lorem.paragraphs(number: 3).join('\n\n')}",
    user: users.sample
  )
  puts "Article créé : #{article.title}"
end

puts "Seed terminé !"
puts "#{User.count} utilisateurs créés"
puts "#{Article.count} articles créés"
