ActiveRecord::Base.logger = Logger.new STDOUT

User.create!(handle: "aahewins", email: "aahewins@protonmail.com", password: "a!!!!!")

Tag.create!(name: "Mathematics",                  css: "blue calculator icon")
Tag.create!(name: "discrete mathematics",         css: 'braille icon')
Tag.create!(name: "group theory",                 css: 'circle outline')
Tag.create!(name: "linear algebra",               css: 'chess board icon')

Tag.create!(name: "Computer Science",             css: "microchip icon")
Tag.create!(name: "algorithms",                   css: 'terminal icon')
Tag.create!(name: "theoretical computer science", css: 'sitemap icon')
Tag.create!(name: "cybersecurity",                css: 'shield alternate')

Tag.create!(name: "Conspiracy",                   css: "red eye icon")
Tag.create!(name: "flat earth",                   css: "globe icon")
Tag.create!(name: "9/11",                         css: "fighter jet icon")
Tag.create!(name: "aliens",                       css: "question circle outline icon")

Tag.create!(name: "Shitposts",                    css: "red thumbs down outline icon")
