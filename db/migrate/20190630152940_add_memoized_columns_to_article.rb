class AddMemoizedColumnsToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :title_katex, :string, null: true
    add_column :articles, :tldr_katex, :text, null: true
    add_column :articles, :body_katex, :text, null: true
  end
end
