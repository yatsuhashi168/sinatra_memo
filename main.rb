require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  title =  params[:name]
  content = params[:content]
  id = if Dir.empty?('./memos')
         1
       else
         Dir.glob('*', base: 'memos').last[/\d{1,}/].to_i + 1
       end
  memo = {'id' => id, 'title' => title, 'content' => content}
  File.open("./memos/memo_#{id}.json", 'w') do |file|
    JSON.dump(memo, file)
  end
  redirect to('/')
end

get '/detail' do
  erb :detail
end

get '/edit' do
  erb :edit
end


