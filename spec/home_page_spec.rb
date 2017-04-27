require_relative '../server.rb'
require 'rack/test'

RSpec.describe 'server' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'displays homepage' do
    get '/'
    expect(last_response.status).to eq(200)
  end

  context 'rendering json of disruptions' do

    def get_first_disruption
      VCR.use_cassette('disruptions') do
        get '/disruptions'
        expect(last_response.body).to be_a(String)
        JSON.parse(last_response.body).first
      end
    end

    before(:context) do
      @first_disruption = get_first_disruption
    end

    it 'gets a commentary of disruption' do
      expect(@first_disruption["commentary"]).to eq "[A3211] Upper Thames Street (EC4R/EC4V) (Westbound) between Cousin Lane and Queen Street Place - Lane one (of two) closed to facilitate high voltage repair works. "
    end

    it 'gets the status of a disruption' do
      expect(@first_disruption['status']).to eq 'Active'
    end

    it 'gets an array of coordinates to display points' do
      expect(@first_disruption["display_points"].first).to eq({ "lat" => 51.510725, "lng" => -0.092483 })
    end

  end
end
