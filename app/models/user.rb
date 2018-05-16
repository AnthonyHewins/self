class User < PermissionModel
  include Gravtastic
  has_gravatar


  has_many :articles, foreign_key: :author_id, dependent: :nullify


  attr_accessor :password


  before_save :encrypt_pw, :downcase_fields
  after_save lambda {|user| user.password = nil}
  

  PW_MIN_LENGTH = 6
  validates :password,
            presence: true,
            confirmation: true,
            length: {maximum: 512, minimum: PW_MIN_LENGTH},
            format: {with: /(?=.*[a-zA-Z])(?=.*[0-9!@\\\#$%^&*()<>]).{#{PW_MIN_LENGTH},}/,
                     message: "must contain a letter and a special character defined below."},
            if: lambda {|user| user.new_record? || !user.password.blank?}

  validates :email,
            format: {with: URI::MailTo::EMAIL_REGEXP,
                     message: "is an invalid email format"},
            length: {maximum: 512, minimum: 5},
            uniqueness: {case_sensitive: false}

  validates :handle,
            allow_nil: true,
            length: {minimum: 1, maximum: 64},
            uniqueness: {case_sensitive: false},
            exclusion: {in: %w(anonymous Anonymous)}

  # The user should not have a confirmation token unless it's just been created
  validates :confirm_token, absence: true, on: :update
  
  def register_email(date=nil)
    raise ArgumentError, "Can only pass an override for register_email when Rails.env == testing" unless Rails.env.test?
    if tried_registering_15_min_ago?(date || DateTime.now)
      self.update!(confirm_token: nil, registration_attempt_time: nil, email_confirmed: true)
    else
      return false
    end
  end

  def has_permission?(*models, &block)
    theyre_all_permission_models = models.all? {|model| model.is_a? PermissionModel}
    raise TypeError, "All models must be instances of PermissionModel" unless theyre_all_permission_models
    has_access = self.admin? || models.all? {|model| model.owner == self}
    has_access &&= block.call if block_given?
    return has_access
  end

  def owner
    self
  end
  
  def self.authenticate(email, pw)
    user = find_by email: email
    return nil if user.nil?
    hashed_pw = BCrypt::Engine.hash_secret(pw, user.password_salt)
    hashed_pw == user.password_hash ? user : nil
  end

  private
  def encrypt_pw
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
    
  def tried_registering_15_min_ago?(date)
    # Edge case protection
    return false if self.registration_attempt_time.nil?

    # Is TimeRegistered + (60s * 15 min/s) in the future compared to right now?
    (self.registration_attempt_time.to_time + (60 * 15)) > date.to_time
  end

  def downcase_fields
    self.email&.downcase!
    self.handle&.downcase!
  end
end
