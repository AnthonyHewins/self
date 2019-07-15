module ArticleFillHelper
  def random_fill_in(opts={})
    find("#title").set fill_with(opts[:title], default: :TITLE_MIN)
    find("#tldr").set fill_with(opts[:tldr], default: :TLDR_MAX)
    find("#body").set fill_with(opts[:body], default: :BODY_MIN)
  end

  private
  def fill_with(var, default:)
    case var
    when Integer
      FFaker::BaconIpsum.characters var
    when NilClass
      FFaker::BaconIpsum.characters ArticleValidator.const_get(default)
    when String
      var
    end
  end
end
