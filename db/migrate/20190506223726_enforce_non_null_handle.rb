class EnforceNonNullHandle < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.change :handle, :string, null: false
    end

    change_table :articles do |t|
      t.change :title, :string, null: false
      t.change :body, :text, null: false
    end

    change_table :tags do |t|
      t.change :name, :string, null: false
      t.change :css, :string, null: false
    end
  end
end
