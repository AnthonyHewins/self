class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_hash
      t.string :password_salt
      t.string :handle

      t.timestamps
    end

    create_table :articles do |t|
      t.string :title
      t.text :body
      t.text :tldr
      t.integer :author_id

      t.timestamps
    end

    add_foreign_key :articles, :users, column: :author_id
  end
end
