require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students_array = []
    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_profile_link = "#{student.attr('href')}"
        student_location = student.css('.student-location').text
        student_name = student.css('.student-name').text
        students_array << {name: student_name, location: student_location, profile_url: student_profile_link}
      end
    end
    students_array
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    attributes_hash = {}
    links = profile_page.css(".social-icon-container").children.css("a").map { |element| element.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        attributes_hash[:linkedin] = link
      elsif link.include?("github")
        attributes_hash[:github] = link
      elsif link.include?("twitter")
        attributes_hash[:twitter] = link
      else
        attributes_hash[:blog] = link
      end
    end
    attributes_hash[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    attributes_hash[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")
    attributes_hash
  end
end

