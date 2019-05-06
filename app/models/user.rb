class User < PermissionModel
  has_secure_password

  has_many :articles, foreign_key: :author_id, dependent: :nullify

  validate :custom_validations

  PW_MIN_LENGTH = 6
  PW_MAX_LENGTH = 72
  validates :password,
            presence: true,
            confirmation: true,
            length: {minimum: PW_MIN_LENGTH, maximum: PW_MAX_LENGTH},
            format: {with: /(?=.*[a-zA-Z])(?=.*[0-9!@\\\#$%^&*()<>]).{#{PW_MIN_LENGTH},#{PW_MAX_LENGTH}}/,
                     message: "must contain a letter and a special character."},
            if: lambda {|user| user.new_record? || !user.password.blank?}

  HANDLE_MIN_LENGTH = 1
  HANDLE_MAX_LENGTH = 64
  validates :handle,
            presence: true,
            length: {minimum: HANDLE_MIN_LENGTH, maximum: HANDLE_MAX_LENGTH},
            uniqueness: true

  before_save do |record|
    record.handle.strip!
  end

  def has_permission?(*models, &block)
    all_permission_models = models.all? {|model| model.is_a? PermissionModel}
    raise TypeError, "All models must be instances of PermissionModel" unless all_permission_models
    has_access = self.admin? || models.all? {|model| model.owner == self}
    block_given? ? has_access && block.call : has_access
  end

  def owner
    self
  end

  private
  def custom_validations
    if handle.nil?
      errors.add(:handle, "Handle cannot be null")
    else
      errors.add(:handle, "Anonymous is a reserved handle") if handle.downcase! == "anonymous"
    end
  end
end
