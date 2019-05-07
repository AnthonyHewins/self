require 'rails_helper'
require_relative '../custom_matchers/have_alias_method'

RSpec.describe Article, type: :model do
  it {should validate_presence_of :title}
  it {should validate_length_of(:title)
               .is_at_least(Article::TITLE_MIN)
               .is_at_most(Article::TITLE_MAX)}

  it {should validate_length_of(:tldr).is_at_most Article::TLDR_MAX}

  it {should validate_presence_of :body}
  it {should validate_length_of(:body).is_at_least(Article::BODY_MIN)}
  
  it {should have_and_belong_to_many(:tags)}

  it {should have_alias_method :owner, :author}

  before :each do
    @obj = create :article
  end

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
    it 'uses q to find with ::omnisearch' do
      expect(Article.search @obj.title).to include @obj
    end

    it 'uses :tags to find with ::search_by_tags' do
      expect(Article.search author: @obj.author).to include @obj
    end

    it 'uses :tags to find with ::search_by_tags' do
      @obj.update tags: [create(:tag)]
      expect(Article.search tags: Tag.first).to include @obj
    end
  end

  context '#author' do
    it 'optionally allows nil' do
      expect(create(:article, author: nil)).to be_valid
    end

    it 'works correctly with a valid foreign key' do
      expect(create(:article, author: create(:user))).to be_valid
    end

    it 'blocks saving if the FK is invalid' do
      expect{create(:article, author_id: 9999)}.to raise_error(ActiveRecord::InvalidForeignKey)
    end
  end

  context 'private:' do
    context '::omnisearch(query_chain, query)' do
      %i(title tldr body).each do |sym|
        it "finds based on :#{sym}, case-insensitively" do
          expect(Article.send :omnisearch, Article.all, @obj.send(sym).upcase).to include(@obj)
        end

        it "finds based on :#{sym}" do
          expect(Article.send :omnisearch, Article.all, @obj.send(sym)).to include(@obj)
        end
      end
    end

    context '::search_by_tags(query_chain, tags)' do
      before :all do
        @bind = lambda do |i|
          Article.send :search_by_tags, Article.left_outer_joins(:tags).all, i
        end
      end
      
      before :each do
        @tag = create :tag
        @obj.update tags: [@tag]
      end

      it 'raises TypeError on anything else' do
        expect {@bind.call 1}.to raise_error TypeError
      end

      it 'returns query_chain on Nil' do
        expect(@bind.call nil).to match_array Article.left_outer_joins(:author).all
      end

      it 'returns articles that have tags equal to arg2 on Tag' do
        expect(@bind.call @tag).to include @obj
      end

      it 'returns query_chain back on empty String' do
        expect(@bind.call '').to match_array Article.all
      end

      it 'returns articles that have tags with names equal to arg2 on String' do
        expect(@bind.call @tag.name).to include @obj
      end

      it 'returns articles that have tags with names equal to arg2.downcase on String' do
        expect(@bind.call @tag.name.upcase).to include @obj
      end

      it 'returns articles that have tags in arg2 on Array' do
        expect(@bind.call Tag.all.to_a).to include @obj
      end

      it 'returns articles that have tags in arg2 on ActiveRecord::Relation' do
        expect(@bind.call Tag.all).to include @obj
      end
    end

    context '::search_by_author(query_chain, author)' do
      before :all do
        @bind = lambda do |i|
          Article.send :search_by_author, Article.left_outer_joins(:author).all, i
        end
      end
      
      before :each do
        @author = create :user
        @obj.update author: @author
      end

      it 'raises TypeError on anything else' do
        expect {@bind.call 1}.to raise_error TypeError
      end

      it 'returns query_chain on Nil' do
        expect(@bind.call nil).to eq Article.left_outer_joins(:author).all
      end

      it 'returns articles that have author equal to arg2 on Author' do
        expect(@bind.call @author).to include @obj
      end

      it 'returns query_chain back on empty String' do
        expect(@bind.call '').to match_array Article.all
      end

      it 'returns articles that have author with names equal to arg2 on String' do
        expect(@bind.call @author.handle).to include @obj
      end
    end
  end
end
