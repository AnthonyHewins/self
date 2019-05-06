class GetSecurePasswordUsers < ActiveRecord::Migration[5.2]
  def change
    %i(
        registration_attempt_time
        confirm_token
        email_confirmed
        password_salt
        password_hash
     ).each do |sym|
      remove_column :users, sym
    end
  end
end
