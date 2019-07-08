#require 'rails_helper'
#require 'concerns/taggable'
#
#RSpec.describe Concerns::Taggable do
#  before :all do
#    @obj = Object.new
#    @obj.extend Concerns::Taggable
#  end
#
#  context '#create_with_tags(klass, params)' do
#    it "returns false if params doesnt satisfy klass's requirements" do
#      expect(@obj.create_with_tags(Article.new)).to be false
#    end
#
#    it "keeps the tags errors" do
#      tag = create :tag
#      article = build :article, tags: [tag, tag]
#      @obj.create_with_tags(article)
#      expect(article.invalid?).to be true
#    end
#
#    it "keeps the model's errors" do
#      article = Article.new
#      @obj.create_with_tags(article)
#      expect(article.invalid?).to be true
#    end
#  end
#
#  context '#update_with_tags' do
#    before :each do
#      @article = create :article
#    end
#
#    it "keeps the tags errors" do
#      tag = create :tag
#      @obj.update_with_tags(@article, tags: [tag, tag])
#      expect(@article.invalid?).to be true
#    end
#
#    it "keeps the model's errors" do
#      @obj.update_with_tags(@article, title: "")
#      byebug
#      expect(@article.errors[:title].count).to be > 0
#    end
#  end
#end
