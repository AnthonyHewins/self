RSpec.shared_examples 'validation_lib/taggable' do |validator, klass, max, dupes: false|
  before :each do
    @obj = create klass
  end

  context 'saving tags' do
    context 'when dealing with duplicates' do
      before :each do
        @tag = create :tag
        @obj.tags = [@tag] * 2
      end

      if dupes
        it 'allows dupes' do
          validator.validate @obj
          expect(@obj.tags).to eq [@tag, @tag]
        end
      else
        it 'removes duplicates silently when prompted to (default behavior)' do    
          validator.validate @obj
          expect(@obj.tags).to eq [@tag]
        end
      end
    end

    it 'adds an error to errors[:tags] when too many tags are supplied' do
      too_many = max.succ
      @obj.tags = create_list :tag, too_many
      validator.validate @obj
      expect(@obj.errors[:tags]).to include "max is #{max}, got #{too_many}"
    end
  end
end
