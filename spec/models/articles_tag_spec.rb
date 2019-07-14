require 'rails_helper'

require_relative 'shared/unique_index'

RSpec.describe ArticlesTag, type: :model do
  include_examples 'unique index', :articles_tag, :article, :tag
  
  it {should belong_to(:article)}
  it {should belong_to(:tag)}
end
