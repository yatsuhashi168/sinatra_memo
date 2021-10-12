require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :index
end

get '/new' do
  erb :new
end

get '/detail' do
  erb :detail
end

get '/edit' do
  erb :edit
end


