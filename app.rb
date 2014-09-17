#! /bin/env ruby

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pry'
require 'fileutils'

class MyApp < Sinatra::Base
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

  get '/' do
    "test"
  end

  post '/test' do 
    while @@lock do 
      sleep 1
    end
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
    ret, output_tmp = bundle_install
    output += output_tmp
    ret, output_tmp = run_test
    output += output_tmp
    print_output output
    `cd #{File.dirname __FILE__}`
    @@running = nil

    if !@@builds_err.empty?
      process
    end 
  end

  def pull_the_repo 
    output = `git clone #{@@running["repository"]["url"]} builds/#{@@running["build_id"]}`
    if !$?.success?
      return false, output
    end

    `cd builds/#{@@running["build_id"]}`
    output = `git checkout #{@@running["head_commit"]["id"]}`
    if !$?.success?
      return false, output
    end

    return true, output
  end

  def bundle_install
    output = `bundle install --local --path .bundle || gem install debugger-ruby_core_source --install-dir ./.bundle/ruby/1.9.1 && bundle install --local --path .bundle`
    if !$?.success?
      return false, output
    end

    return true, output
  end

  def run_test
    output = `./scripts/run_test_parallel`
    if !$?.success?
      return false, output
    end

    return true, output
  end


  def print_output output
    dir = File.dirname __FILE__
    f = File.new "#{dir}/logs/#{@@running["build_id"]}.log", "w"
    f.print output
    f.close
  end


  run! if app_file == $0
end
