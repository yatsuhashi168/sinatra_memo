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

  def connect_database
    PG.connect(dbname: 'sinatra_memo')
  end
end

get '/' do
  @title = '一覧'
  connection = connect_database
  @memos = connection.exec('SELECT * FROM memos ORDER BY id') do |results|
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
  name = params[:name]
  content = params[:content]
  connection = connect_database
  connection.prepare('new', 'INSERT INTO memos(name, content) VALUES ($1, $2)')
  connection.exec_prepared('new', [name, content])

  redirect to('/')
end

get '/memo/:id' do
  @memo = connect_database.exec("SELECT * FROM memos WHERE id = #{params[:id]}")[0]
  @title = @memo['name']
  erb :detail
end

delete '/memo/:id' do
  connect_database.exec("DELETE FROM memos WHERE id = #{params[:id]}")
  redirect to('/')
end

patch '/memo/:id' do
  memo_name = params[:name]
  memo_content = params[:content]
  connection = connect_database
  connection.prepare('patch', "UPDATE memos SET name = $1, content = $2 WHERE id = #{params[:id]}")
  connection.exec_prepared('patch', [memo_name, memo_content])

  redirect to("/memo/#{params[:id]}")
end

get '/memo/:id/edit' do
  @memo = connect_database.exec("SELECT * FROM memos WHERE id = #{params[:id]}")[0]
  @title = @memo['name']
  erb :edit
end
