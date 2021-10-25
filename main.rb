require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  @title = '一覧'
  @memos = []
  Dir.glob('*', base: 'memos').each do |file|
    File.open("./memos/#{file}") do |memo|
      @memos << JSON.load(memo)
    end
  end
  erb :index
end

get '/new' do
  @title = '新規作成'
  erb :new
end

post '/new' do
  title =  params[:name]
  content = params[:content]
  id = if Dir.empty?('./memos')
         1
       else
         Dir.glob('*', base: 'memos').last[/\d+/].to_i + 1
       end
  memo = {'id' => id, 'title' => title, 'content' => content}
  File.open("./memos/memo_#{id}.json", 'w') do |file|
    JSON.dump(memo, file)
  end
  redirect to('/')
end

get '/memo/:id' do
  erb :detail
end

get '/edit' do
  erb :edit
end
