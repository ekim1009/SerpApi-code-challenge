require 'nokogiri'
require 'date'

class Parser2
  def self.process(html)
    doc = Nokogiri::HTML(html)
    
    result = { "videos" => [] }
    carousel = doc.at_css('g-scrolling-carousel')
    return result unless carousel

    carousel.css('g-inner-card').each do |div|
      href = div.at_css('a')['href']
      alt = div.at_css('div.dbhQEb.yTYr4d')&.text
      extension = Date.today
      image_tag = div.at_css('img')
      image = image_tag['src'] || image_tag['data-src']

      result["videos"] << {
        "name" => alt,
        "extension" => [extension],
        "link" => "www.google.com/#{href}",
        "image" => image
      }
    end
    result
  end
end
