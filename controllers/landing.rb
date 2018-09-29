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
  uri = "#{CONECTIONNODE}/admin/panel"
  response = HTTParty.get(uri)
  @data = response  
  @contadores = JSON.parse(@data['counters'])
  puts @contadores
  @clientes = JSON.parse(@data['clientes'])
  @citas = JSON.parse(@data['citas'])
  erb :"modules/home/admin", :layout => :"layouts/admin"

end

get '/admin/citas' do 
  uri = "#{CONECTIONNODE}/admin/citas"
  response = HTTParty.get(uri)
  @data = response  
  @citas = JSON.parse(@data['citas'])


  erb :"modules/home/adminparts/citas", :layout => :"layouts/admin"
end

get '/admin/citas/:id' do
    uri = "#{CONECTIONNODE}/admin/cita?id=#{params[:id]}"
    response = HTTParty.get(uri)
    @data = response  
    @cita = JSON.parse(@data['cita'])

    erb :"modules/home/adminparts/vista_de_la_cita", :layout => :"layouts/admin"
end


get '/admin/clientes' do 
  uri = "#{CONECTIONNODE}/admin/clientes"
  response = HTTParty.get(uri)
  @data = response  
  @clientes = JSON.parse(@data['clientes'])


  erb :"modules/home/adminparts/clientes", :layout => :"layouts/admin"
end

get '/admin/abogados' do 
  uri = "#{CONECTIONNODE}/admin/abogados"
  response = HTTParty.get(uri)
  @data = response  
  @abogados = JSON.parse(@data['abogados'])


  erb :"modules/home/adminparts/abogados", :layout => :"layouts/admin"
end

get '/admin/abogado' do 
  uri = "#{CONECTIONNODE}/api/law/show?token=#{params[:token]}"
  response = HTTParty.get(uri)
  @data = response  
  @abogado = JSON.parse(@data['abogado'])

  erb :"modules/home/adminparts/perfil_abogado", :layout => :"layouts/admin"
end


get '/admin/casos' do 
  uri = "#{CONECTIONNODE}/admin/casos"
  response = HTTParty.get(uri)
  @data = response  
  @casos = JSON.parse(@data['casos'])


  erb :"modules/home/adminparts/casos", :layout => :"layouts/admin"
end

get '/admin/caso' do 
  uri = "#{CONECTIONNODE}/admin/caso?token=#{params[:token]}"
  response = HTTParty.get(uri)
  @data = response  
  @caso = JSON.parse(@data['caso'])

  erb :"modules/home/adminparts/vista_del_caso", :layout => :"layouts/admin"
end

get '/admin/tickets' do 
  #uri = "#{CONECTIONNODE}/admin/citas"
  uri = "#{CONECTIONNODE}/admin/tickets"
  response = HTTParty.get(uri)
  @data = response  
  @tickets = JSON.parse(@data['tickets'])

  puts @tickets


  erb :"modules/home/adminparts/tickets", :layout => :"layouts/admin"
end





def current_route(path)
  route = path.split('?')
  session['route'] = route
end







