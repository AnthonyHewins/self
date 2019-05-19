module ArticleFillHelper
  def random_fill_in(opts={})
    find("#title").set opts.fetch(:title, FFaker::BaconIpsum.characters(1000))
    find("#tldr").set opts.fetch(:tldr, FFaker::BaconIpsum.characters(1000))
    find("#body").set opts.fetch(:body, FFaker::BaconIpsum.characters(1000))
  end
end
