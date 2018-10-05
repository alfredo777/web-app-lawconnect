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
require 'rerun'

configure do
    enable :sessions unless test?
    set :session_secret, "secret"
end

CONECTIONNODE = "https://access-point-law-connect.herokuapp.com"


get "/" do
  @categorias = [
    {:id => 1, :title => "Derecho Laboral", :search => "derecho laboral"},
    {:id => 2, :title => "Derecho Administrativo", :search => "derecho administrativo"},
    {:id => 3, :title => "Derechos de Autor", :search => "derechos de autor"},
    {:id => 4, :title => "Derecho de lo Familiar", :search => "derecho familiar"},
    {:id => 5, :title => "Derecho Fiscal", :search => "derecho fiscal"},
    {:id => 6, :title => "Derecho Penal", :search => "derecho penal"},
    {:id => 7, :title => "Derecho Civil", :search => "derecho civil"},
    {:id => 8, :title => "Derecho Mercantil", :search => "derecho mercantil"}
  ]
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

  loggin_filter
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
  loggin_filter
  uri = "#{CONECTIONNODE}/admin/citas"
  response = HTTParty.get(uri)
  @data = response  
  @citas = JSON.parse(@data['citas'])


  erb :"modules/home/adminparts/citas", :layout => :"layouts/admin"
end

get '/admin/citas/:id' do
    loggin_filter
    uri = "#{CONECTIONNODE}/admin/cita?id=#{params[:id]}"
    response = HTTParty.get(uri)
    @data = response  
    @cita = JSON.parse(@data['cita'])

    erb :"modules/home/adminparts/vista_de_la_cita", :layout => :"layouts/admin"
end


get '/admin/clientes' do 
  loggin_filter
  uri = "#{CONECTIONNODE}/admin/clientes"
  response = HTTParty.get(uri)
  @data = response  
  @clientes = JSON.parse(@data['clientes'])


  erb :"modules/home/adminparts/clientes", :layout => :"layouts/admin"
end

get '/admin/cliente' do 
  loggin_filter
  uri = "#{CONECTIONNODE}/api/cliente/show?email=#{params[:email]}"
  response = HTTParty.get(uri)
  @data = response  
  @cliente = JSON.parse(@data['cliente'])



  erb :"modules/home/adminparts/perfil_cliente", :layout => :"layouts/admin"
end


get '/admin/cliente/register' do 
  loggin_filter
  erb :"modules/home/adminparts/registro_cliente", :layout => :"layouts/admin"
end

get '/admin/abogados' do 
  loggin_filter
  uri = "#{CONECTIONNODE}/admin/abogados"
  response = HTTParty.get(uri)
  @data = response  
  @abogados = JSON.parse(@data['abogados'])


  erb :"modules/home/adminparts/abogados", :layout => :"layouts/admin"
end

get '/admin/abogado' do 
  loggin_filter
  uri = "#{CONECTIONNODE}/api/law/show?token=#{params[:token]}"
  response = HTTParty.get(uri)
  @data = response  
  @abogado = JSON.parse(@data['abogado'])

  erb :"modules/home/adminparts/perfil_abogado", :layout => :"layouts/admin"
end

get '/admin/abogado/register' do 
  loggin_filter
  @categorias = [
    {:id => 1, :title => "Derecho Laboral", :search => "derecho laboral"},
    {:id => 2, :title => "Derecho Administrativo", :search => "derecho administrativo"},
    {:id => 3, :title => "Derechos de Autor", :search => "derechos de autor"},
    {:id => 4, :title => "Derecho de lo Familiar", :search => "derecho familiar"},
    {:id => 5, :title => "Derecho Fiscal", :search => "derecho fiscal"},
    {:id => 6, :title => "Derecho Penal", :search => "derecho penal"},
    {:id => 7, :title => "Derecho Civil", :search => "derecho civil"},
    {:id => 8, :title => "Derecho Mercantil", :search => "derecho mercantil"}
  ]

  puts "Inicializando categorias"
  
  puts @categorias
  erb :"modules/home/adminparts/registro_abogado", :layout => :"layouts/admin"
end


get '/admin/casos' do 
  loggin_filter
  uri = "#{CONECTIONNODE}/admin/casos"
  response = HTTParty.get(uri)
  @data = response  
  @casos = JSON.parse(@data['casos'])


  erb :"modules/home/adminparts/casos", :layout => :"layouts/admin"
end

get '/admin/caso' do 
  loggin_filter
  uri = "#{CONECTIONNODE}/admin/caso?token=#{params[:token]}"
  response = HTTParty.get(uri)
  @data = response  
  @caso = JSON.parse(@data['caso'])

  erb :"modules/home/adminparts/vista_del_caso", :layout => :"layouts/admin"
end

get '/admin/tickets' do 
  loggin_filter
  uri = "#{CONECTIONNODE}/admin/tickets"
  response = HTTParty.get(uri)
  @data = response  
  @tickets = JSON.parse(@data['tickets'])

  puts @tickets


  erb :"modules/home/adminparts/tickets", :layout => :"layouts/admin"
end

get '/admin/admins' do 
  loggin_filter
  uri = "#{CONECTIONNODE}/admin/list_admins"
  response = HTTParty.get(uri)
  @data = response  
  @admins = JSON.parse(@data['admins'])

  puts @admins


  erb :"modules/home/adminparts/administradores", :layout => :"layouts/admin"
end


get '/admin/register' do 
  loggin_filter
  erb :"modules/home/adminparts/register_admin", :layout => :"layouts/admin"
end

get '/admin/secure/delete' do 
  loggin_filter
  uri = "#{CONECTIONNODE}/admin/destroy_admin?id=#{params[:id]}"
  response = HTTParty.get(uri)
  puts response
  redirect '/admin/admins'
end

get '/admin/loggin' do 
 
  erb :"modules/home/adminparts/loggin", :layout => :"layouts/loggin"
end

get '/admin/secure/acces' do 
  uri = "#{CONECTIONNODE}/admin/login_admin?email=#{params[:email]}&password=#{params[:password]}"
  response = HTTParty.get(uri)
  puts response
  response = response['access']
  puts response
  
  if "#{response}" == "#{true}"
     session[:admin] = true
     redirect '/admin'
  else
    redirect '/admin/loggin'
  end

  erb :"modules/home/adminparts/loggin", :layout => :"layouts/loggin"
end

get 'admin/secure/exit' do 
  session[:admin] = false
  redirect '/admin/loggin'
end





def current_route(path)
  route = path.split('?')
  session['route'] = route
end

def loggin_filter
    puts ">>>>> #{session[:admin]}"
    if "#{session[:admin]}" == "#{true}"
      puts "#{session[:admin]}"
    else
      redirect '/admin/loggin'
    end
end







