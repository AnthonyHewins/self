class SplitHabtm < ActiveRecord::Migration[5.2]
  def change
    drop_table :articles_tags

    create_table :articles_tags do |t|
      t.references :article
      t.references :tag
    end
  end
end
