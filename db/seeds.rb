require 'csv'

puts "Loading semantic ui icons to seed..."
icons = File.read Rails.root.join 'db/semantic_ui_icons.txt'
puts "Done, loading default tags..."
tags = CSV.read Rails.root.join 'db/default_tags.csv'
puts "Those files both existed, the rest should be easy"

ActiveRecord::Base.logger = Logger.new STDOUT

ActiveRecord::Base.transaction do
  unless User.exists?(handle: "ahewins")
    User.create!(handle: "ahewins", password: "a!!!!!", admin: true)
  end

  icons.split("\n").each do |name|
    SemanticUiIcon.find_or_create_by(icon: name.strip)
  end

  tags.each do |name, icon, color|
    icon = SemanticUiIcon.find_by icon: icon.strip
    tag = Tag.find_or_create_by(name: name.strip)
    tag.update(semantic_ui_icon: icon, color: color.strip)
  end
end
