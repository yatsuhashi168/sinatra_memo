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
end

get '/' do
  @title = '一覧'
  @memos = []
  connection = PG.connect(dbname: 'sinatra_memo')
  connection.exec('SELECT * FROM memos ORDER BY id') do |results|
    results.each do |memo|
      @memos << memo
    end
  end

  erb :index
end

get '/new' do
  @title = '新規作成'
  erb :new
end

post '/new' do
  name = h(params[:name])
  content = h(params[:content])
  connection = PG.connect(dbname: 'sinatra_memo')
  connection.exec("INSERT INTO memos(name, content) VALUES ('#{name}', '#{content}')")

  redirect to('/')
end

get '/memo/:id' do
  @memo = PG.connect(dbname: 'sinatra_memo').exec("SELECT * FROM memos WHERE id = #{params[:id]}")
  @title = @memo[0]['name']
  @memo_id = @memo[0]['id']
  @memo_name = @memo[0]['name']
  @memo_content = @memo[0]['content']
  erb :detail
end

delete '/memo/:id' do
  PG.connect(dbname: 'sinatra_memo').exec("DELETE FROM memos WHERE id = #{params[:id]}")
  redirect to('/')
end

patch '/memo/:id' do
  memo_name = h(params[:name])
  memo_content = h(params[:content])
  PG.connect(dbname: 'sinatra_memo').exec("UPDATE memos SET name = '#{memo_name}', content = '#{memo_content}' WHERE id = #{params[:id]}")
  redirect to("/memo/#{params[:id]}")
end

get '/memo/:id/edit' do
  @memo = PG.connect(dbname: 'sinatra_memo').exec("SELECT * FROM memos WHERE id = #{params[:id]}")
  @title = @memo[0]['name']
  @memo_id = @memo[0]['id']
  @memo_name = @memo[0]['name']
  @memo_content = @memo[0]['content']
  erb :edit
end
