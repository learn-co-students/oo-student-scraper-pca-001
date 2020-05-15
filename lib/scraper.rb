require 'open-uri'
require 'pry'

class Scraper
  def self.scrape_index_page(index_url)
    array = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css("div.student-card").each do |student|
      hash = {}
      hash[:name] = student.css("div.card-text-container h4.student-name").text
      hash[:location] = student.css("div.card-text-container p.student-location").text
      hash[:profile_url] = student.css("a").attribute("href").value
      array << hash
    end
    array
  end

  def self.scrape_profile_page(profile_url)
    hash = {}

    doc = Nokogiri::HTML(open(profile_url))

    doc.css("div.social-icon-container a").each do |a|
      link = a.attribute("href").text
      if link.include?("twitter")
        hash[:twitter] = link
      elsif link.include?("linkedin")
        hash[:linkedin] = link
      elsif link.include?("github")
        hash[:github] = link
      else
        hash[:blog] = link
      end
    end

    hash[:profile_quote] = doc.css("div.profile-quote").text
    hash[:bio] = doc.css("div.description-holder p").text
    hash
  end
end
