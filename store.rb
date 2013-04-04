# gem install --version 1.3.0 sinatra
require 'pry'
gem 'sinatra', '1.3.6'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
 
 
get '/users' do
  @title="Our Users"
  db = SQLite3::Database.new "store.sqlite3"
  db.results_as_hash = true
  @rs = db.prepare('SELECT * FROM users;').execute
  erb :show_users
end
 
get '/products' do
  @title = "Products"
  db = SQLite3::Database.new "store.sqlite3"
  db.results_as_hash = true
  @rs = db.prepare('SELECT * FROM products;').execute
  erb :show_products
end
 
get '/' do
  @title="The Sinatra Store"
  erb :home
end
 
 
 
 
 
 
 
 
 
=begin
 
  <form method='post' action='/create'>
    <input type='text' name='name' autofocus>
    <input type='text' name='photo'>
    <input type='text' name='breed'>
    <button>dog me!</button>
  </form>
 
 
  post '/create' do
  end
 
 
  redirect '/'
 
=end