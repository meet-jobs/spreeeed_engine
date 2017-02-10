# SpreeeedEngine
Spreeeed Engine 是一種泛用型管理介面。主要的目標在於開發一個兼容彈性與客製化系統。

## Usage


### 如何安裝
在你應用中的 Gemfile 加入這一行。

```ruby
gem 'spreeeed_engine', :git => 'git://github.com/MidnightBlue/spreeeed_engine.git'
```

在 Console 中執行安裝。
```bash
$ bundle
```

Spreeeed Engine 會預設安裝以下的 gem。
* rails 5+
* jquery-rails
* devise
* simple_form

### 設定 devise
```bash
$ bundle exec rails generate devise:install
$ bundle exec rails generate devise User
$ bundle exec rake db:migrate
```

並在 routes.rb 中依據需求調整所需的 controllers，下述範例中將只允許登入登出與註冊。
```ruby
devise_for :users, skip: [:confirmations, :passwords, :unlocks, :omniauth_callbacks]
```

Spreeeed Engine 將會產生預設登入畫面。

編輯 `config/initializers/devise.rb`，並將登出預設的 HTTP Method 改為 GET。
```ruby
# The default HTTP method used to sign out a resource. Default is :delete.
config.sign_out_via = :get
```

若您的 devise resource 名稱不為 User 的話，可以建立 config 檔案，並在 config 檔案中覆寫 devise resource 名稱。

### 建立 config
在 Console 底下輸入：
```bash
$ touch config/initializers/spreeeed_engine.rb
```
打開 spreeeed_engine.rb 後，輸入：
```bash
SpreeeedEngine.setup do |config|
  config.namepsace            = 'backend',
  config.devise_auth_resource = 'member' # default is user
end
```


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
