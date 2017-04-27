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
      status = disruption.css('status').first.text
      start_time = format_datetime(disruption.css('startTime').first.text)
      end_time_node = disruption.css('endTime').first
      end_time = end_time_node ? format_datetime(end_time_node.text) : nil

      { commentary: comment, status: status, start_time: start_time, end_time: end_time, display_points: display_points(disruption) }
    end
  end

  private

  def format_datetime(datetime_string)
    DateTime.parse(datetime_string).strftime('%H:%M:%S %d %B %Y')
  end

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
