class ExtendUsersAndArticlesAddCategories < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.boolean :admin, default: false
      t.boolean :trusted, default: false
    end
    
    create_table :tags do |t|
      t.string :text
    end

    create_table :articles_tags do |t|
      t.belongs_to :article, index: true
      t.belongs_to :tag, index: true
    end
  end
end
