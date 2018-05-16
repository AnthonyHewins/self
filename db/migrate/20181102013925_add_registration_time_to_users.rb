class AddRegistrationTimeToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.datetime :registration_attempt_time
    end
  end
end
