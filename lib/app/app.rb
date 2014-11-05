#! /bin/env ruby

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pry'
require 'fileutils'

module JamCI
  class App < Sinatra::Base
    configure :production, :development do
      enable :logging
      set :bind, '0.0.0.0'
    end

    configure :development do
      register Sinatra::Reloader
    end

    @@tot = 0
    @@running = nil
    @@builds_arr = Array.new
    @@lock = false

    get '/test' do
      "test"
    end

    post '/test' do 
      @@lock = true
      @@tot += 1     
      request.body.rewind
      data = JSON.parse request.body.read
      data["build_id"] = @@tot
      @@builds_arr.push data
      @@lock = false
      process
    end

    def process
      if @@running
        return
      end 

      @@running = @@builds_arr.shift
      `cd #{File.dirname __FILE__}`
      ret, output = pull_the_repo 
      ret, output_tmp = run_test
      output += output_tmp
      print_output output
      `cd #{File.dirname __FILE__}`
      @@running = nil

      if !@@builds_err.empty?
        process
      end 
    end

   

    run! if app_file == $0
  end
end

