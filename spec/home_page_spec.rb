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

    def get_disruption
      VCR.use_cassette('disruptions') do
        get '/disruptions'
        expect(last_response.body).to be_a(String)
        JSON.parse(last_response.body)[1]
      end
    end

    before(:context) do
      @disruption = get_disruption
    end

    it 'gets a commentary of disruption' do
      expect(@disruption["commentary"]).to eq "Cannon Street (EC4) (Westbound) between [A3] King William Street and Queen Victoria Street - Closed during road maintenance on behalf of the City of London. Westbound traffic is diverted via King William Street, Lombard Street and Mansion House Street to Queen Victoria Street."
    end

    it 'gets the status of a disruption' do
      expect(@disruption['status']).to eq 'Active'
    end

    it 'gets the start time of a disruption ' do
      expect(@disruption['start_time']).to eq '05:00:00 03 January 2017'
    end

    it 'gets the end time of a disruption ' do
      expect(@disruption['end_time']).to eq '04:00:00 01 May 2017'
    end

    it 'gets an array of coordinates to display points' do
      expect(@disruption["display_points"].first).to eq({ "lat" => 51.511823, "lng" => -0.091533 })
    end
  end
end
