# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'erb'
require 'pg'
enable :method_override

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def connecting_database
    @connection ||= PG.connect(dbname: 'sinatra_memo')
  end
end

get '/' do
  @title = '一覧'
  @memos = connecting_database.exec('SELECT * FROM memos ORDER BY id') do |results|
    results.map do |memo|
      memo
    end
  end
  erb :index
end

get '/memo/new' do
  @title = '新規作成'
  erb :new
end

post '/memo' do
  connecting_database.prepare('new', 'INSERT INTO memos(name, content) VALUES ($1, $2)')
  connecting_database.exec_prepared('new', [params[:name], params[:content]])

  redirect to('/')
end

get '/memo/:id' do
  @memo = connecting_database.exec("SELECT * FROM memos WHERE id = #{params[:id]}")[0]
  @title = @memo['name']
  erb :detail
end

delete '/memo/:id' do
  connecting_database.exec("DELETE FROM memos WHERE id = #{params[:id]}")
  redirect to('/')
end

patch '/memo/:id' do
  connecting_database.prepare('patch', "UPDATE memos SET name = $1, content = $2 WHERE id = #{params[:id]}")
  connecting_database.exec_prepared('patch', [params[:name], params[:content]])

  redirect to("/memo/#{params[:id]}")
end

get '/memo/:id/edit' do
  @memo = connecting_database.exec("SELECT * FROM memos WHERE id = #{params[:id]}")[0]
  @title = @memo['name']
  erb :edit
end
