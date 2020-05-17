require 'open-uri'
require 'pry'

class Scraper
  def self.scrape_index_page(index_url)
    html = Nokogiri::HTML(open(index_url))
    students = []
    html.css(".student-card").each do |card|
      students << {
        name: card.css(".student-name").text,
        location: card.css(".student-location").text,
        profile_url: card.css("a")[0].attributes["href"].value,
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html = Nokogiri::HTML(open(profile_url))
    student_info_hash = {}
    # set up socials
    html.css(".social-icon-container a").each_with_index do |element, i|
      site_name = element["href"].split(/\:|\.|\//)[3]
      site_name = "linkedin" if element["href"].include? "linkedin"
      site_name = "blog" if i == 3
      student_info_hash[site_name.to_sym] = element["href"]
    end
    student_info_hash[:profile_quote] = html.css(".profile-quote").text
    student_info_hash[:bio] = html.css(".description-holder p").text
    student_info_hash
  end
end
