require 'rails_helper'
require 'katex'

RSpec.describe KatexParser do
  context '#before_save' do
    before :each do
      @parser = KatexParser.new(html: %i[body], no_html: %i[tldr title])
      @obj = create :article
    end
    
    it 'nils out blank fields and returns' do
      @obj.tldr = ''
      @parser.before_save(@obj)
      expect(@obj.tldr).to be nil
    end

    it 'strips whitespace regardless of syntax' do
      @obj.tldr = '   1    '
      @parser.before_save(@obj)
      expect(@obj.tldr).to eq '1'
    end

    it "if no katex is detected in field (no '$$' delimiters), keeps field_katex nil" do
      @obj.tldr = "No katex"
      @parser.before_save @obj
      expect(@obj.tldr_katex).to be nil
    end

    it "if Katex is in field but has syntax errors it adds an error to the model" do
      @obj.tldr = "Invalid $$\frac{$$"
      @parser.before_save @obj
      expect(@obj.errors[:tldr].count).to be > 0
    end

    it "if katex is detected in field, parses it and places it in field_katex" do
      katex = "a^2"
      @obj.tldr = "#{FFaker::Lorem.words(20)} $$#{katex}$$"
      @parser.before_save @obj
      expect(@obj.tldr_katex).to include Katex.render(katex)
    end

    context 'when strictly parsing a field without HTML,' do
      it 'strips all HTML away outside of Katex tags' do
        @obj.tldr = "<i>Injection</i> $$a^2$$"
        @parser.before_save @obj
        expect(@obj.tldr_katex).to eq "Injection #{Katex.render('a^2')}"
      end
    end

    context 'when parsing a field with HTML,' do
      it 'keeps HTML outside of Katex tags' do
        katex = 'a^2'
        garbage = "<i>CKEditor markup</i> #{FFaker::Lorem.words 10}"
        @obj.body = "#{garbage} $$#{katex}$$"
        @parser.before_save @obj
        expect(@obj.body_katex).to eq "#{garbage} #{Katex.render('a^2')}"
      end
    end
  end
end
