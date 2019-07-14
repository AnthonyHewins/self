class CreateVerificationsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :verifications_users do |t|
      t.references :user
      t.references :tag
    end

    add_index :verifications_users, %i[user_id tag_id], unique: true
  end
end
