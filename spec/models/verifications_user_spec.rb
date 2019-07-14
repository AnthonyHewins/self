require 'rails_helper'

require_relative 'shared/unique_index'

RSpec.describe VerificationsUser, type: :model do
  include_examples 'unique index', :verifications_user, :user, :tag
  
  it {should belong_to(:user)}
  it {should belong_to(:tag)}
end
