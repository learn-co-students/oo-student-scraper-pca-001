require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)

  index_page = Nokogiri::HTML(open(index_url))
  student_list = []

  index_page.css("div.roster-cards-container").collect do |s|
    s.css(".student-card a").each do |student|
      student_profile_link = "#{student.attr('href')}"
      student_location = student.css('.student-location').text
      student_name = student.css('.student-name').text
      student_list << {name: student_name, location: student_location, profile_url: student_profile_link}
    end
  end
  student_list
end

  def self.scrape_profile_page(profile_url)

  profile = Nokogiri::HTML(open(profile_url))
  student_list = {}
  profile.css("div.social-icon-container a").each do |student|
    if student.attribute("href").value.include?("twitter")
      student_list[:twitter] = student.attribute("href").value
    elsif student.attribute("href").value.include?("linkedin")
      student_list[:linkedin] = student.attribute("href").value
    elsif student.attribute("href").value.include?("github")
      student_list[:github] = student.attribute("href").value
    else student_list[:blog] = student.attribute("href").value
    end
  end
  student_list[:profile_quote] = profile.css("div.profile-quote").text
  student_list[:bio] = profile.css("div.description-holder p").text
  student_list
  end
end


def self.scrape_index_page(index_url)

  index_page = Nokogiri::HTML(open(index_url))
  students = []

  index_page.css("div.roster-cards-container").each do |card|
    card.css(".student-card a").each do |student|
      student_profile_link = "#{student.attr('href')}"
      student_location = student.css('.student-location').text
      student_name = student.css('.student-name').text
      students << {name: student_name, location: student_location, profile_url: student_profile_link}
    end
  end
  students
end