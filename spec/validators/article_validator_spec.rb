require 'rails_helper'
require 'article_validator'
require 'validation_lib/attachment_validator'

RSpec.describe ArticleValidator do
  before :all do
    @obj = ArticleValidator.new
  end

  it { expect(ArticleValidator.included_modules).to include ValidationLib::AttachmentValidator}
  
  context "constants" do
    [[:TITLE_MIN, 10], [:TITLE_MAX, 1000], [:TLDR_MAX, 1500], [:BODY_MIN, 128]].each do |name, val|
      it "ArticleValidator::#{name} equals #{val}" do
        expect(ArticleValidator.const_get name).to eq val
      end
    end
  end

  context '#validate(record)' do
    before :each do
      @article = create :article
    end

    it 'adds an error if the article has more than 5 tags' do
      @article.tags = create_list(:tag, 6)
      @obj.validate @article
      expect(@article.save).to be false
    end

    it 'adds an error if duplicate tags are found' do
      tag = create :tag
      @article.tags = [tag,tag]
      @obj.validate @article
      expect(@article.save).to be false
    end
  end
end
