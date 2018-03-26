# go to top 10 page and parse ten url
require 'open-uri'
require 'nokogiri'

url = "https://www.fbi.gov/wanted/topten"
html_content = open(url).read
doc = Nokogiri::HTML(html_content)

top_ten_urls = {}

# visit each link to profile

# 1. We get the HTML page content thanks to open-uri

# 2. We build a Nokogiri document from this file


# 3. We search for the correct elements containing the items' title in our HTML doc
doc.search("h3.title a").each do |element|
  # 4. For each item found, we extract its title and print it
  name = element.text.strip
  # name => url
  top_ten_urls[name] = element.attr('href')
end


def process(name, url)

# instantiate hash

criminal_hash = {}

# opens url and read content as string
criminal_html = open(url).read
# nokogiri to process HTML
doc = Nokogiri::HTML(criminal_html)
# grab reward ..wanted-person-reward p .innerText
criminal_reward = doc.search(".wanted-person-reward p")[0].text
  # locate specific informaion regarding
  # $$$$ and set :REWARD key to $$ valu
criminal_hash[:reward] = criminal_reward.scan(/\$\d+(?:,\d+)*/).first
criminal_hash[:name] = name
# return hash

criminal_hash
end

criminal_array_sorted = []

top_ten_urls.each do |name, url|
criminal_array_sorted << process(name, url)
end

puts criminal_array_sorted

# criminal_doc = {}
# fugutive_html = {}
# top_ten_urls.each do |link|
#   fugutive_html = open(link).read
#   criminal_doc = Nokogiri::HTML(fugutive_html)
# end

# puts criminal_doc
# pull name etc wanted-person-description

# - height
# - hair
# - weight
# -

# pull the wanted-person-reward

# regex to grab reward
