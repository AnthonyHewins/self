class User < PermissionModel
  has_secure_password

  has_many :articles, foreign_key: :author_id, dependent: :nullify

  validate :custom_validations

  PW_MIN = 6
  PW_MAX = 72 # this constraint is given by has_secure_password
  validates :password,
            presence: true,
            length: {minimum: PW_MIN},
            format: {with: /(?=.*[a-zA-Z])(?=.*[0-9!@\\\#$%^&*()<>]).{#{PW_MIN},#{PW_MAX}}/,
                     message: "must contain a letter and a special character."},
            if: lambda {|user| user.new_record? || !user.password.blank?}

  HANDLE_MIN = 1
  HANDLE_MAX = 64
  validates :handle,
            presence: true,
            length: {in: HANDLE_MIN..HANDLE_MAX},
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
