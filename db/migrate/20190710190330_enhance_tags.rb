class EnhanceTags < ActiveRecord::Migration[5.2]
  def change
    remove_column :tags, :css
    add_column :tags, :color, :string, default: nil

    create_table :semantic_ui_icons do |t|
      t.string :icon
    end

    add_reference :tags, :semantic_ui_icon
  end
end
