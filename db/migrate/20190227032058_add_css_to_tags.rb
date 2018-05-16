class AddCssToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :css, :string, null: true
    rename_column :tags, :text, :name
  end
end
