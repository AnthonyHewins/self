ActiveRecord::Base.logger = Logger.new STDOUT

User.create!(handle: "aahewins", password: "a!!!!!")

Tag.create!(name: "Mathematics",                  css: "blue calculator icon")
Tag.create!(name: "discrete mathematics",         css: 'orange braille icon')
Tag.create!(name: "group theory",                 css: 'red circle outline icon')
Tag.create!(name: "linear algebra",               css: 'violet chess board icon')

Tag.create!(name: "Computer Science",             css: "grey microchip icon")
Tag.create!(name: "algorithms",                   css: 'green terminal icon')
Tag.create!(name: "theoretical computer science", css: 'olive sitemap icon')
Tag.create!(name: "cybersecurity",                css: 'blue shield alternate icon')

Tag.create!(name: "Conspiracy",                   css: "red eye icon")
Tag.create!(name: "flat earth",                   css: "black globe icon")
Tag.create!(name: "9/11",                         css: "grey fighter jet icon")
Tag.create!(name: "aliens",                       css: "yellow question circle outline icon")

Tag.create!(name: "Shitposts",                    css: "red thumbs down outline icon")
