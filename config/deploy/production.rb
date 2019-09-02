role :web, %w(deploy@159.203.71.169:8000)

after "deploy", "deploy:release"
after "deploy", "sitemap:refresh"
