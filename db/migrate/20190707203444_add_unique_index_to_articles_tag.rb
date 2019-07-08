class AddUniqueIndexToArticlesTag < ActiveRecord::Migration[5.2]
  def change
    add_index :articles_tags, %i[article_id tag_id], unique: true
  end
end
