#===============================================================================
# This seed file should be idempotent.
#===============================================================================

ActiveRecord::Base.logger = Logger.new STDOUT

unless User.exists?(handle: "aahewins")
  User.create!(handle: "aahewins", password: "a!!!!!")
end

upsert = lambda do |name, css|
  tag = Tag.find_or_create_by(name: name)
  tag.update!(name: name, css: "blue calculator icon")
end

upsert.call "mathematics",                  "blue calculator icon"
upsert.call "discrete mathematics",         'orange braille icon'
upsert.call "group theory",                 'red circle outline icon'
upsert.call "linear algebra",               'violet chess board icon'

upsert.call "computer science",             "grey microchip icon"
upsert.call "algorithms",                   'green terminal icon'
upsert.call "theoretical computer science", 'olive sitemap icon'
upsert.call "cybersecurity",                'blue shield alternate icon'

upsert.call "conspiracy",                   "red eye icon"
upsert.call "flat earth",                   "black globe icon"
upsert.call "9/11",                         "grey fighter jet icon"
upsert.call "aliens",                       "yellow question circle outline icon"

upsert.call "shitposts",                    "red thumbs down outline icon"
