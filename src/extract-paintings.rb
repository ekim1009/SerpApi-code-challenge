# require 'cgi'
require 'nokogiri'

html1 = File.read("../files/van-gogh-paintings.html")
html2 = File.read("../files/top-movies-2024.html")
html3 = File.read("../files/how-to-tie-a-tie.html")
doc1 = Nokogiri::HTML(html1)
doc2 = Nokogiri::HTML(html2)
doc3 = Nokogiri::HTML(html3)

carousel1 = doc1.at_css('.wDYxhc')

result1 = {"artworks" => []}

carousel1.css('a').each do |a|
  href = a['href']
  alt = a.at_css('img')['alt']
  extension = a.at_css('div.cxzHyb')&.text
  image = a.at_css('img')['src']

  result1["artworks"] << {
    "name" => alt,
    "extension" => [extension],
    "link" => "www.google.com/#{href}",
    "image" => image
  }
end

carousel2 = doc2.at_css('g-scrolling-carousel')

result2 = {"pasta recipes" => []}

carousel2.css('g-inner-card').each do |div|
  href = div.at_css('a')['href']
  alt = div.at_css('div.dbhQEb.yTYr4d')&.text
  extension = '2024'
  image_tag = div.at_css('img')
  image = image_tag['src'] || image_tag['data-src']

  result2["pasta recipes"] << {
    "name" => alt,
    "extension" => [extension],
    "link" => "www.google.com/#{href}",
    "image" => image
  }
end

carousel3 = doc3.at_css('g-scrolling-carousel')

result3 = {"tying a tie" => []}

carousel3.css('g-inner-card').each do |div|
  href = div.at_css('a')['href']
  alt = div.at_css('div.dbhQEb.yTYr4d')&.text
  extension = '2024'
  image_tag = div.at_css('img')
  image = image_tag['src'] || image_tag['data-src']

  result3["tying a tie"] << {
    "name" => alt,
    "extension" => [extension],
    "link" => "www.google.com/#{href}",
    "image" => image
  }
end


puts result3

