# gem install --version 1.3.0 sinatra
# require 'pry'
gem 'sinatra', '1.3.6'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'better_errors'

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
  sql = "SELECT * FROM products;"
  @rs = @db.execute(sql)
  erb :show_products
end

get '/users' do
  @title="Our Users"
  sql = "SELECT * FROM users;"
  @rs = @db.execute(sql)
  erb :show_users
end

get '/products/new' do
  @title="Add A Product"
  erb :new_product
end

post '/products/new' do
  @title = "Product Added"
  name = params[:product_name]
  price = params[:product_price]
  on_sale = params[:on_sale]
  sql = "INSERT INTO products('name', 'price', 'on_sale') VALUES('#{name}', '#{price}', '#{on_sale}');"
  @rs = @db.execute(sql)

  @name = name
  @price = price
  erb :product_created
end

get '/products/:id' do
  id = params[:id]
  sql = "SELECT * FROM products WHERE id='#{id}';"
  @row = @db.get_first_row(sql)

  @title = @row['name']

  erb :product_detail
end

get '/products/:id/edit' do
  @title = "Update Somethin'"
  @id = params[:id]
  sql = "SELECT * FROM products WHERE id='#{@id}';"
  @row = @db.get_first_row(sql)

  erb :product_update
end

post '/products/:id/edit' do
  @title = "Updated!"
  @id = params[:id]
  name = params[:product_name]
  price = params[:product_price]
  on_sale = params[:on_sale]
  sql = "UPDATE products SET name = '#{name}', price = '#{price}', on_sale = '#{on_sale}'  WHERE id='#{@id}';"

  @db.execute(sql)

  @name = name
  @price = price

  erb :product_updated
end

delete '/products/:id' do
  @id = params[:id]
  sql = "DELETE FROM products WHERE id = '#{@id}';"
  @db.execute(sql)

  redirect "/products"

end
