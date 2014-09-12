#! /bin/env ruby

require 'sinatra'
require 'sinatra/reloader'
require 'json'

class MyApp < Sinatra::Base
  configure :production, :development do
    enable :logging
  end

  configure :development do
    register Sinatra::Reloader
  end

  @@tot = 0
  @@running_num = 0
  @@builds_arr = Array.new

  get '/' do
    "test"
  end

  post '/test' do 
    logger.info request.body
    @@tot += 1     
    data = JSON.parse request.body
    repo = data.repository
    repo_url = repo.url
    logger.info repo_url
    puts repo_url
    "test"
  end

  def pull_the_repo
    
  end

  run! if app_file == $0
end
