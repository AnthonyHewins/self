username = "aahewins"
default_pw = "a!!!!!"
User.create! handle: "aahewins", email: "aahewins@protonmail.com", password: default_pw
puts "Creating aahewins with default pw #{default_pw}, be sure to change..."

ActiveRecord::Base.logger = Logger.new STDOUT

Tag.create!(name: "Mathematics",      css: "blue calculator icon")
Tag.create!(name: "Computer Science", css: "microchip icon")
Tag.create!(name: "Conspiracy",       css: "red eye icon")
Tag.create!(name: "Shitposts",        css: "red thumbs down outline icon")
