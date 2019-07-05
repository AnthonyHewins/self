require 'user_validator'

class User < PermissionModel
  has_secure_password

  has_many :articles, foreign_key: :author_id, dependent: :nullify

  has_one_attached :profile_picture

  validates_with UserValidator

  validates :password,
            presence: true,
            length: {minimum: UserValidator::PW_MIN},
            format: {with: UserValidator::PW_REGEX,
                     message: "must contain a letter and a special character."},
            if: lambda {|user| user.new_record? || !user.password.blank?}

  validates :handle,
            presence: true,
            length: {in: UserValidator::HANDLE_MIN..UserValidator::HANDLE_MAX},
            uniqueness: true

  before_save do |record|
    record.handle.strip!
  end

  def has_permission?(*models, &block)
    raise NoMethodError unless models.all? {|model| model.respond_to? :owner}
    has_access = self.admin? || models.all? {|model| model.owner == self}
    block_given? ? has_access && block.call : has_access
  end

  def owner
    self
  end
end
