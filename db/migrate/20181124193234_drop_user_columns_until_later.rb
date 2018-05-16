class DropUserColumnsUntilLater < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.remove :admin
      t.remove :trusted
    end
  end
end
