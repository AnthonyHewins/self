require 'rails_helper'
require 'ffaker'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) {{
    handle: FFaker::HipsterIpsum.characters(ArticleValidator::TITLE_MAX),
  }}

  let(:invalid_attributes) {{
    author: 1,
    created_at: DateTime.now,
    updated_at: DateTime.now,
  }}

  let(:valid_session) {{user_id: create(:user).id}}
  let(:valid_admin_session) {{user_id: create(:user, admin: true).id}}
end
