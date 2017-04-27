require 'sinatra'
require './lib/tims_feed'

get '/' do
  erb :index
end

get '/disruptions' do
  information_points = TimsFeed.new.information_points
  content_type 'application/json'
  information_points.to_json
end
