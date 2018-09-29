# encoding: utf-8

require 'rubygems'
require 'sinatra'
require './controllers/landing'
Encoding.default_external = Encoding::UTF_8  
run Sinatra::Application