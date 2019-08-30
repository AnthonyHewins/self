# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "sudobangbang"
set :repo_url, "git@github.com:AnthonyHewins/self.git"
set :deploy_to, "~/var/www/sudobangbang"
append :linked_dirs, "storage"

after 'deploy:published', 'sitemap:refresh'
