require 'rails_helper'

RSpec.describe "articles/show", type: :view do
  before(:each) do
    # Stub current_user
    view.define_singleton_method(:current_user) do
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end

  context '' do
    before :each do
      @article = create :article
      render
    end

    context 'in any context,' do
      %i[tldr title body].each do |attr|
        it "renders attribute :#{attr} (doesnt test katex rendering)" do
          expect(rendered).to include @article.send attr
        end
      end

      it 'shows the view count' do
        expect(rendered).to include "View count: #{@article.views}"
      end
      
      it 'renders the author handle' do
        expect(rendered).to include @article.author.handle
      end
    end

    context "as a regular user/not logged in user," do
      it 'does not show the edit link' do
        expect(rendered).to_not include "Edit article"
      end

      it 'does not show the delete link' do
        expect(rendered).to_not include "Delete article"
      end
    end
  end

  context 'when the owner of the article,' do
    before :each do
      user = create :user
      session[:user_id] = user.id
      @article = create :article, author: user
      render
    end

    it 'shows the edit link' do
      expect(rendered).to include "Edit article"
    end

    it 'shows the delete link' do
      expect(rendered).to include "Delete article"
    end
  end

  context 'when an admin and not the owner,' do
    before :each do
      user = create :user, admin: true
      session[:user_id] = user.id
      @article = create :article
      render
    end

    it 'shows the superuser edit link' do
      expect(rendered).to include "Edit article as admin"
    end

    it 'shows the superuser delete link' do
      expect(rendered).to include "Delete article as admin"
    end
  end
end
