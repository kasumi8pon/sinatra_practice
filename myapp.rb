require 'sinatra'

patch '/edit' do
  @body = params[:body]
  @id = params[:id]
  File.write("memo/#{@id}.txt", @body)
  redirect '/'
end

delete '/:id' do
  @id = params[:id]
  File.delete("memo/#{@id}.txt")
  redirect '/'
end

get '/' do
  filenames = Dir.glob('memo/*').sort.reverse
  @ids = filenames.map { |f| File.basename(f, '.txt') }
  @titles =
    filenames.map do |f|
      title = File.open(f).gets
      title || '(no title)'
    end
  erb :index
end

get '/new' do
  erb :new
end

get '/:id' do
  @id = params[:id]
  @memo = File.open("memo/#{@id}.txt").read
  erb :show
end

post '/create' do
  @body = params[:body]
  ids = Dir.glob('memo/*').map { |f| File.basename(f, '.txt') }
  datetime = Time.now.strftime('%Y%m%d%H%M%S')
  @id = datetime
  digit = 0
  while ids.include?(@id)
    digit += 1
    @id = datetime + digit.to_s
  end
  File.write("memo/#{@id}.txt", @body)
  redirect '/'
end
