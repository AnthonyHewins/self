require 'rails_helper'

RSpec.describe ArticlesTag, type: :model do
  it {should belong_to(:article)}
  it {should belong_to(:tag)}

  # Workaround for the following not working:
  # it {should validate_uniqueness_of(:article).scoped_to(:tag)}
  # https://github.com/thoughtbot/shoulda-matchers/issues/814
  it 'forces unique (article_id, tag_id) pairs' do
    article, tag = create(:article), create(:tag)
    create :articles_tag, article: article, tag: tag
    expect{create :articles_tag, article: article, tag: tag}
      .to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Article has already been taken')
  end
end
