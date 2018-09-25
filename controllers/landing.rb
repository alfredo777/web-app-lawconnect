require 'sinatra'
require 'sinatra/base'
require 'useragent'
require 'pony'
require 'i18n'
require 'handlebars'
require 'active_support'
require 'active_support/time'
require 'strftime'
require 'httparty'

enable :sessions

CONECTIONNODE = "https://access-point-law-connect.herokuapp.com"


get "/" do
  erb :"modules/home/index", :layout => :"layouts/application"
end

######### atributos de vista pública ##########

get "/search" do
  current_route(request.path_info)
  uri =	"#{CONECTIONNODE}/api/global/search?search=#{params[:search]}"
  response = HTTParty.get(uri)
  @search = response  
  @search = JSON.parse(@search["abogados"])
  puts @search
  erb :"modules/home/search", :layout => :"layouts/layout_single"

end

get "/profile" do
  current_route(request.path_info)
  uri = "#{CONECTIONNODE}/api/law/show?token=#{params[:token]}"
  response = HTTParty.get(uri)
  @abogado = response  
  @abogado = JSON.parse(@abogado["abogado"])
  puts @abogado
  erb :"modules/home/profile", :layout => :"layouts/layout_single"
end

get '/admin' do
  erb :"modules/home/admin", :layout => :"layouts/admin"

end

def current_route(path)
  route = path.split('?')
  session['route'] = route
end




