class ForceExistenceOnJoinTables < ActiveRecord::Migration[5.2]
  def change
    change_column :articles_tags, :article_id, :bigint, null: false
    change_column :articles_tags, :tag_id, :bigint, null: false
  end
end
