# gem install --version 1.3.0 sinatra
# require 'pry'
gem 'sinatra', '1.3.6'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'better_errors'
require 'open-uri'
require 'json'
require 'uri'

before do
  @db = SQLite3::Database.new "store.sqlite3"
  @db.results_as_hash = true
end

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path("..", __FILE__)
end

get '/' do
  @title="Online Tradin' Post"
  erb :home
end
 
get '/products' do
  @title = "Products"
  @rs = @db.execute("SELECT * FROM products;")
  erb :show_products
end

get '/users' do
  @title="Our Users"
  @rs = @db.execute("SELECT * FROM users;")
  erb :show_users
end

get '/users.json' do
  @rs = @db.execute("SELECT id, name from users;")
  @rs.to_json

end

get '/products/new' do
  @title="Add A Product"
  erb :new_product
end


get '/products/search' do
  @title = "Search Results"
  @q = params[:q]
  file = open("http://search.twitter.com/search.json?q=#{URI.escape(@q)}")
  @results = JSON.load(file.read)

  erb :search_results
end

post '/products/new' do
  @title = "Product Added"
  name = params[:product_name]
  price = params[:product_price]
  on_sale = params[:on_sale]
  @rs = @db.execute("INSERT INTO products('name', 'price', 'on_sale') VALUES('#{name}', '#{price}', '#{on_sale}');")

  @name = name
  @price = price
  erb :product_created
end

get '/products/:id' do
  id = params[:id]
  @row = @db.get_first_row("SELECT * FROM products WHERE id='#{id}';")

  # @title = @row['name']

  erb :product_detail
end


get '/products/:id/edit' do
  @title = "Update Somethin'"
  @id = params[:id]
  @row = @db.get_first_row("SELECT * FROM products WHERE id='#{@id}';")

  erb :product_update
end

post '/products/:id/edit' do
  @title = "Updated!"
  @id = params[:id]
  name = params[:product_name]
  price = params[:product_price]
  on_sale = params[:on_sale]

  @db.execute("UPDATE products SET name = '#{name}', price = '#{price}', on_sale = '#{on_sale}'  WHERE id='#{@id}';")

  @name = name
  @price = price

  erb :product_updated
end

delete '/products/:id' do
  @id = params[:id]
  @db.execute("DELETE FROM products WHERE id = '#{@id}';")

  redirect "/products"

end
