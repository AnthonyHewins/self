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

  context ':tldr_image validation' do
    before :each do
      @file = Tempfile.new("toobig")
    end

    context "if size is greater than #{Article::TLDR_IMAGE_MAX} bytes" do
      before :each do
        @file.write "a" * (Article::TLDR_IMAGE_MAX + 1)
        @file.rewind
        @obj.tldr_image.attach(io: @file, filename: "x", content_type: "image/jpeg")
      end
      
      it "purges the attachment" do
        @obj.save
        expect(@obj.tldr_image.attachment).to be nil
      end
      
      it "adds an error" do
        expect(@obj.save).to be false
      end
    end

    context "if the content type isn't an image" do
      before :each do        
        @obj.tldr_image.attach(io: @file, filename: "x", content_type: "application/exe")
      end

      it "purges the attachment" do
        @obj.save
        expect(@obj.tldr_image.attachment).to be nil
      end
      
      it "raises an error" do
        expect(@obj.save).to be false
      end
    end
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

  it {should have_alias_method :owner, :author}
end
