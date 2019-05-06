module Login  
  def login(user=nil, password=nil)
    if user.nil?
      password = "a!!!!!"
      user = create :user, password: password
    else
      raise ArgumentError, "Supply a password with the user" if password.nil?
    end
    
    visit login_path
    fill_in id: "handle", with: user.handle
    fill_in id: "password", with: password
    byebug
    click_on "Login"
    user
  end

  def logout
    click_on 'Log out'
  end
end
