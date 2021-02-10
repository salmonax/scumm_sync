require 'sinatra'
require 'redcarpet'
require 'yaml'

require './lib/scumm_sync.rb'
require './lib/ft_offsets.rb'
require './lib/mi2_offsets.rb'

$VERBOSE = nil # We're using a toplevel class var and don't want to hear about it.

def baking?
  ENV['APP_ENV'] == 'bake' # Set by bake.rb
end

if development?
  require 'sinatra/reloader'
  require 'dotenv'
  Dotenv.load
end

unless baking?
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET']
end

configure do
  if baking?
    puts '-=== RUNNING SERVER IN BAKE MODE ===-'
    puts 'Writing index.html to ./public and exiting!'
  end
  @@ft = ScummSync.new(FT::data)
  @@ft.load_xml
  @@ft.build_synced_hash
  @@ft.ft_en_ru_kludge
  @@ipfs_hash = ENV['SCUMM_SPEECH_HASH']
end

get "/" do
  if baking?
    bake_file = File.new './public/index.html', 'w'
    bake_file.puts(haml :flexy)
    bake_file.close
    puts "Finished writing ./public/index.html!"
  end
  haml :flexy
end


__END__

@@ layout
!!!5
%html
  %head
    %script
      :plain
        // Ping the ipfs route, in case it's stale
        fetch("https://ipfs.io/ipfs/#{@@ipfs_hash}");

    %style
      :plain
        .locale-heading {
          float: left;
          padding: 5px;
          margin-right: 1px;
          border-style: none;
          color: white;
          background: rgb(100,100,100);
          border-color: rgb(0,0,0);
          width: 300px;
        }
        .locale-item {
          padding: 10px;
          margin-right: 1px;
          border-style: none;
          color: black;
          background: rgb(200,200,200);
          border-color: rgb(0,0,0);
        }
        .flex-container {
          display: flex;
          flex-flow: row;
          justify-content: space-around;
          background: rgb(100,200,200);
          height: 200px;
        }
        .row-container {
          display: flex;
          float: none;
          / border-style: solid;
          width: 100%;
          / height: 100px;
        }
        .row-item {
          / box-sizing: border-box;
          padding: 5px;
          border: 1px solid;
          border-color: grey;
          width: 100%;
          / float: left;
          overflow: hidden;
          / white-space: nowrap;
        }
        .heading {
          color: white;
          background: rgb(100,100,100);
        }
        .entry-speechless {
          background: rgb(200,200,200);
        }
        .entry-speechful {
          background: rgb(200,300,200);
        }
        .entry-speechful a {
          color: black;
          text-decoration: none;
        }
        .entry-speechful:hover {
          background: rgb(250,300,200)
        }
        .entry-speechless:hover{
          background: rgb(220,200,200);
        }
    %script{src:"/javascripts/jquery-2.1.0.min.js"}
    %script{src:"/javascripts/responsivevoice.js"}
  %body
    %h2 Full Throttle Dialogue in Five Languages
    =yield

@@ root
- @@ft.locales.each do |locale|
  .locale-heading
    =locale
    - @@ft.synced[locale].each do |k,v|
      .locale-item
        #{v[:line]}
