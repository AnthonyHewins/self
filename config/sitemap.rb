SitemapGenerator::Sitemap.default_host = "http://sudo-bangbang.com"
SitemapGenerator::Sitemap.public_path = 'public/sitemap'

# The paths that need to be included into the sitemap.
SitemapGenerator::Sitemap.create do
  Article.find_each do |article|
    add article_path(article.id, locale: :en, changefreq: :weekly, lastmod: article.updated_at)
  end
end
