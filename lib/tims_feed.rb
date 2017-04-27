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
      comment = get_disruption_text(disruption, 'comments')
      status = get_disruption_text(disruption, 'status')
      start_time = format_datetime(get_disruption_text(disruption, 'startTime'))
      end_time = format_datetime(get_disruption_text(disruption, 'endTime'))

      { commentary: comment, status: status, start_time: start_time, end_time: end_time, display_points: display_points(disruption) }
    end
  end

  private

  def get_disruption_text(disruption, css_selector)
    element = disruption.css(css_selector).first
    element ? element.text : nil
  end

  def format_datetime(datetime_string)
    datetime_string ? DateTime.parse(datetime_string).strftime('%H:%M:%S %d %B %Y') : nil
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
