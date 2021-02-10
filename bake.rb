# This is the simplest way to coerce the sinatra-dependent
# app to spit out an index.html that makes use of Sinatra's
# layout interpolation and haml function.

require './app'
require 'rack/test'

ENV['APP_ENV'] = 'bake'

browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
browser.get '/'
