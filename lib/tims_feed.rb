require 'httparty'
require 'nokogiri'
class TimsFeed
  TIMS_FEED_URL = 'https://data.tfl.gov.uk/tfl/syndication/feeds/tims_feed.xml'

  attr_reader :doc
  def initialize
    @doc = Nokogiri::XML(response.body)
  end

  def information_points
    disruptions.map do |disruption|
      comment = disruption.css('comments').first.text
      { commentary: comment, display_points: display_points(disruption) }
    end
  end

  private

  def response
    @response ||= HTTParty.get(TIMS_FEED_URL)
  end

  def disruptions
    doc.css('Disruption')
  end

  def display_points(disruption)
    disruption.css('coordinatesLL').map {|coordinates_element| create_location(coordinates_element.text) }
  end

  def create_location(coordinates)
    longitude, latitude = coordinates.split(",")
    { lat: latitude.to_f, lng: longitude.to_f }
  end
end
