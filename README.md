[![Hack k2works/sukusuku on Nitrous.IO](https://d3o0mnbgv6k92a.cloudfront.net/assets/hack-s-v1-7475db0cf93fe5d1e29420c928ebc614.png)](https://www.nitrous.io/hack_button?source=embed&runtime=rails&repo=k2works%2Fsukusuku)
[![Stories in Ready](https://badge.waffle.io/k2works/sukusuku.png?label=ready&title=Ready)](http://waffle.io/k2works/sukusuku)
[![Build Status](https://travis-ci.org/k2works/sukusuku.svg?branch=master)](https://travis-ci.org/k2works/sukusuku)

すくすくスクラム広島第5回「スクラムやってみる」
===================

# 目的
デモアプリ

# 前提
| ソフトウェア   | バージョン   | 備考        |
|:---------------|:-------------|:------------|
| OS X           |10.8.5        |             |
| ruby           |2.0.0         |             |
| rvm            |1.24.0        |             |
| rbricks        |2.0.5         |             |
| heroku-toolbelt |3.6.0        |             |

+ [Herokuにサインアップしている](https://id.heroku.com/signup/devcenter)
+ [Heroku Toolbeltをインストールしている](https://toolbelt.heroku.com/)
+ [LiveReloadをChromeにインストールしている](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei)

# 構成
+ [環境セットアップ](#1)
+ [アプリケーションのセットアップ](#2)
+ [アプリケーションのデプロイ](#3)
+ [その他追加設定](#4)

# 詳細

## <a name="1">環境セットアップ</a>

```bash
$ rvm install ruby-2.0.0-p247
$ rvm use ruby-2.0.0
$ rvm gemset create sukusuku
$ rvm use ruby-2.0.0@sukusuku
$ gem install railsbricks
$ gem install rails --version=4.0.4
```
## <a name="2">アプリケーションのセットアップ</a>

### 基本セットアップ

```bash
$ git clone https://github.com/LeanEC/mvp_smoke_tester.git
$ bundle
$ rake db:migrate
$ rake db:seed
$ rails s
```

### 日本語対応
Gemfile編集
```
gem 'i18n_generators'
```
日本語ファイル生成
```
$ bundle
$ rails g i18n ja
```
モデルの日本語対応  
_config/locales/translation_ja.yml_
```yml
ja:
  activerecord:
    models:
      user: ユーザー

    attributes:
      user:
        admin: 管理者
        email: eメール
        username: ユーザー名
        password: パスワード
        password_confirmation: パスワード再確認
        current_password: 現在のパスワード
```

### RSpec対応
#### Gemfile編集
```
group :test, :development do
  gem "rspec-rails", '~> 2.14.1'
  gem "guard-rspec"
  gem "factory_girl_rails"
  gem "spring"
  gem "guard-livereload", require: false
  gem "spring-commands-rspec"
end
```
#### FactoryGirlの設定  
_spec/spec_helper.rb_の最後に以下を追加
```ruby
config.before(:all) do
  FactoryGirl.reload
end
```
#### Guardの設定
```bash
$ guard init rspeclivereload
```
生成されたGuardfileから以下の行を変更する

変更前
```
guard :rspec do
```
変更後
```
guard :rspec, cmd: 'spring rspec -f doc' do
```

### Cucumber対応
#### Gemfile編集
```ruby
group :test do
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "guard-cucumber"
end
```
Capybaraのsave_and_open_page実行時にブラウザに出力するようにする
```ruby
group :test do
  gem "capybara", '~> 2.2.1'
  gem "launchy"
end
```
#### Cucumberセットアップ
```bash
$ bundle
$ rails g cucumber:install
$ rake cucumber
```
#### Guardファイル追加
```bash
$ guard init cucumber
```

### ドキュメント環境構築

以下のGemを追加してbundle実行

```Ruby
# Yard
group :test, :development do
  gem 'yard', :require => false
  gem 'yard-cucumber', :require => false
  gem 'redcarpet'
  gem 'guard-yard'
  gem 'yard-rails-plugin', :git => 'https://github.com/ogeidix/yard-rails-plugin.git', :tag => 'v0.0.1'
  gem 'guard-ctags-bundler'
end
```

#### .yardoptsの追加
```
--charset UTF-8
"{lib,app,features}/**/*.{rb,feature}" --plugin yard-cucumber
```

#### Guardファイル追加
```
$ guard init yard
```

#### Yardの確認
```
$ guard
$ open http://localhost:8808
```


## <a name="">アプリケーションのデプロイ</a>
### WebサーバーをUnicornに変更する
#### Gemfile編集
```ruby
gem 'unicorn'
```
#### 設定ファイル作成
```bash
$ bundle
$ touch config/unicorn.rb
```
_config/unicorn.rb_
```ruby
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 15
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
```
### Heroku準備
#### Procfileの作成
_Procfile_
```
web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
```
#### .envファイルの追加
```bash
$ echo "RACK_ENV=development" >>.env
$ echo "PORT=3000" >> .env
$ echo ".env" >> .gitignore
```

#### foreman実行
```bash
$ gem install foreman
$ foreman start
```

### Herokuへデプロイ
```bash
$ heroku login
$ heroku create --addons heroku-postgresql
$ heroku keys:add
$ git push heroku master

### Herokuデーターベースマイグレーション
```bash
$ heroku run rake db:migrate
$ heroku run rake db:seed
```

### Herokuアプリケーションの確認
```bash
$ heroku ps:scale web=1
$ heroku ps
$ heroku open
```
### Herokuアプリケーションの名前変更
```bash
$ heroku apps:rename sukusuku-app
```
サイト確認
http://sukusuku-app.herokuapp.com/

## <a name="4">その他追加設定</a>

### Guardもforemanから呼び出すように変更
_Procfile_
```
guard: bundle exec guard
```

### 日本語対応
#### メニューの日本語対応

_app/views/layouts/_navigation_links.html.erb_を編集

#### Deviseの日本語対応

[devise.ja.yml](https://gist.github.com/yhara/606476)を_config/locales_に保存する。

_app/views/devise/_以下のファイルを編集する。

+ ログイン画面
  + _app/views/devise/sessions/new.html.erb_
  + _app/views/devise/shard/_links.erb_

+ アカウント編集画面
  + _app/views/devise/registrations/edit.html.erb_

+ 管理者画面
  + _app/views/admin/base/index.html.erb_

+ ユーザー画面
  + _app/views/admin/users/index.html.erb_
  + _app/views/admin/users/edit.html.erb_

### Google Analytics対応

#### トラッキングIDの設定
_app/config/application.yml_を作成してトラッキングIDとトラッキングドメインを明記する
```bash
$ rails g figaro:install
```
_application.yml_
```yml
google_analytics_key: "UA-XXXXXXX-XX"
google_analytics_domain: "herokuapp.com"
```
事前にトラッキングIDをGoogleAnlyticsで設定しおく。  
application.ymlはレポジトリ管理対象にはならないのでローカル環境のみで管理する。

#### パーシャル追加
_app/views/layouts/_footer.html.erb_に以下のコードを追加
```html
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', '<%= ENV["google_analytics_key"]%>', '<%= ENV["google_analytics_domain"]%>');  
  ga('send', 'pageview');

</script>
```

#### Turbolinks対応
_app/assets/javascripts/analytics.js.coffee_を追加する
```coffee
$(document).on 'page:change', ->
  if window._gaq?
    _gaq.push ['_trackPageview']
  else if window.pageTracker?
    pageTracker._trackPageview()
```

#### デプロイ
ここまでの作業をコミットした後Figaroでアプリケーションのキー情報をherokuの環境変数に登録。

```bash
$ rake figaro:heroku['sukusuku']
```
Herokuへデプロイ
```bash
$ RAILS_ENV=production rake assets:precompile
$ git add -a
$ git commit -m "assets compiled for Heroku"
$ git push -f heroku master
```

### データベースアノテーション
_Gemfile_に以下を追加
```ruby
group :development do
  gem 'annotate', '2.5.0'
end
```
アノテーション実行
```bash
$ bundle install
$ bundle exec annotate
```
※dbスキーマに変更がある度にbundle exec annotateする必要がある

### Codeclimate対応

#### コードチェックの登録
https://codeclimate.com/にログインする。  
ダッシュボード画面の_Add Open Source Repo_からレポジトリを追加する。

#### コードカバレッジの登録

_Gemfile_に追加する。

```ruby
gem "codeclimate-test-reporter", group: :test, require: nil
```

_spec/spec_helper_の先頭に以下のコードを追加する。
```ruby
require "codeclimate-test-reporter"
 CodeClimate::TestReporter.start
```

_.travis.yml_に以下のコードを追加する。repo_tokenはCodeclimate管理画面の_Settings_メニューのTest Coverageに明記されている。
```yml
 addons:
   code_climate:
     repo_token: 1213....
```

更新を反映
```bash
$ bundle
$ git push origin master
```

# 参照

+ [RailsBricks入門](https://github.com/k2works/rails_bricks_introduction)

+ [RailsBricksのBDD仕様](https://github.com/k2works/rails_bricks_bdd)

+ [ビヘイビア駆動開発入門](https://github.com/k2works/bdd_introduction)

+ [Startbootstrap](http://startbootstrap.com/)

+ [Analytics for Rails](http://railsapps.github.io/rails-google-analytics.html)

+ [laserlemon/figaro](https://github.com/laserlemon/figaro#deployment)

+ [Improve Your Code Quality: Tracking Test Coverage with Travis CI and Code Climate](http://blog.travis-ci.com/2013-09-12-improve-your-codes-quality-tracking-test-coverage-with-travis-ci-and-code-climate/)
