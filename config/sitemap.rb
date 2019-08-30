SitemapGenerator::Sitemap.default_host = "http://sudo-bangbang.com"
SitemapGenerator::Sitemap.public_path = 'public/sitemap'

# The full path to your bucket
SitemapGenerator::Sitemap.sitemaps_host = "https://#{'ENV["S3_BUCKET_NAME"]'}.s3.amazonaws.com"

# The paths that need to be included into the sitemap.
SitemapGenerator::Sitemap.create do
  Article.find_each do |article|
    add article_path(article.slug_en, locale: :en, changefreq: :weekly, lastmod: article.updated_at)
  end
end
