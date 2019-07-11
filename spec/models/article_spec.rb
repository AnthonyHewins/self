require 'rails_helper'
require 'katex'
require_relative '../custom_matchers/have_alias_method'
require_relative '../custom_matchers/validate_with'

RSpec.describe Article, type: :model do
  before :each do
    @obj = create :article
  end

  it {should have_alias_method :owner, :author}

  it {should have_many(:tags).through(:articles_tag)}
  it {should have_many(:articles_tag)}

  it {should belong_to(:author).class_name("User").with_foreign_key(:author_id).optional}

  it {should validate_presence_of :title}
  it {should validate_length_of(:title)
              .is_at_least(ArticleValidator::TITLE_MIN)
              .is_at_most(ArticleValidator::TITLE_MAX)}

  it {should validate_length_of(:tldr).is_at_most ArticleValidator::TLDR_MAX}

  it {should validate_presence_of :body}
  it {should validate_length_of(:body).is_at_least(ArticleValidator::BODY_MIN)}

  it {should validate_numericality_of(:views).is_greater_than_or_equal_to(0)
              .only_integer}

  it {should validate_with(ArticleValidator)}

  context 'katex getters' do
    before :each do
      @word = FFaker::Lorem.word
    end

    %i[title tldr].each do |sym|
      context "#get_#{sym}" do
        it "returns :#{sym} if blank" do
          @obj.send "#{sym}=", @word
          @obj.send "#{sym}_katex=", nil
          expect(@obj.send "get_#{sym}").to eq @word
        end

        it "returns :#{sym}_katex.html_safe if :#{sym}_katex not blank" do
          @obj.send "#{sym}_katex=", @word
          expect(@obj.send "get_#{sym}").to eq @word.html_safe
        end
      end
    end

    context '#get_body' do
      it "returns body.html_safe if body_katex is nil" do
        @obj.body, @obj.body_katex = @word, nil
        expect(@obj.get_body).to eq @word.html_safe
      end

      it "returns body_katex.html_safe if body_katex not blank" do
        @obj.body_katex = @word
        expect(@obj.get_body).to eq @word.html_safe
      end
    end
  end
  
  context '::search(q, tags:, author:)' do
    context 'omnisearch' do
      %i[title tldr body].each do |sym|
        it "finds based on :#{sym}, case-insensitively" do
          expect(Article.search @obj.send(sym)).to include(@obj)
        end
      end
    end

    context 'with tags' do
      before :each do
        @tags = create_list :tag, 2
        @obj.update tags: @tags
      end

      it 'raises TypeError on anything else' do
        expect{Article.search tags: Object.new}.to raise_error TypeError
      end

      it "returns query_chain on nil" do
        expect(Article.search.to_a)
          .to match_array Article.includes(:tags).left_outer_joins(:author).to_a
      end

      it 'finds articles based on the object id' do
        expect(Article.search tags: @tags.first.id).to include @obj
      end

      it 'finds articles based on the object' do
        expect(Article.search tags: @tags.first).to include @obj
      end

      [@tags, @tags.to_a].each do |collection|
        context "on #{collection.class}" do
          it "shows Articles that have all the tags within the collection" do
            expect(Article.search tags: collection).to include @obj
          end

          it "doesnt show things that only have a proper subset of tags given in the collection" do
            new_conditions = @tags + [create(:tag)]
            expect(Article.search tags: new_conditions).to_not include @obj
          end
        end
      end
    end

    context 'with author' do
      before :each do
        @author = create :user
        @obj.update author: @author
      end

      it 'raises TypeError on anything else' do
        expect {Article.search author: 1}.to raise_error TypeError
      end

      [nil, ''].each do |blank|
        it "returns query_chain on #{blank.inspect}" do
          expect(Article.search(author: blank).to_a)
            .to eq Article.left_outer_joins(:tags, :author).all.to_a
        end
      end

      it 'on User finds the users authored articles' do
        expect(Article.search author: @author).to include @obj
      end

      it 'returns articles that have author with names equal to arg2 on String' do
        expect(Article.search author: @author.handle).to include @obj
      end
    end
  end
end
