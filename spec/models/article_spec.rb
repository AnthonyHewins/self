require 'rails_helper'
require_relative '../custom_matchers/have_alias_method'

RSpec.describe Article, type: :model do
  before :each do
    @obj = create :article
  end

  context "constants" do
    [[:TITLE_MIN, 10], [:TITLE_MAX, 1000], [:TLDR_MAX, 1500], [:BODY_MIN, 128]].each do |name, val|
      it "#{name} equals #{val}" do
        expect(Article.const_get name).to eq val
      end
    end
  end

  it {should have_and_belong_to_many(:tags)}

  it {should belong_to(:author).class_name("User").with_foreign_key(:author_id).optional}
  
  it {should validate_presence_of :title}
  it {should validate_length_of(:title)
               .is_at_least(Article::TITLE_MIN)
               .is_at_most(Article::TITLE_MAX)}

  it {should validate_length_of(:tldr).is_at_most Article::TLDR_MAX}

  it {should validate_presence_of :body}
  it {should validate_length_of(:body).is_at_least(Article::BODY_MIN)}

  context 'before_save' do
    it ":tldr is nil'd out when it equals ''" do
      @obj.update tldr: ''
      expect(@obj.tldr).to be nil
    end
    
    %i(title tldr body).each do |sym|
      it "strips :#{sym} before save" do
        old = @obj.send sym
        @obj.update(sym => "   #{old}   ")
        expect(@obj.send(sym)).to eq old
      end
    end
  end

  context '::search(q, tags:, author:)' do
    context 'omnisearch' do
      %i(title tldr body).each do |sym|
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
        expect(Article.search)
          .to match_array Article.left_outer_joins(:tags, :author)
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
          expect(Article.search author: blank)
            .to eq Article.left_outer_joins(:tags, :author).all
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

  it {should have_alias_method :owner, :author}
end
