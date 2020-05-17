require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    student_cards = doc.css(".student-card")

    student_cards.map do |card|
    {
      name: card.css(".student-name").text,
      location: card.css(".student-location").text,
      profile_url: card.css("a").attribute("href").text
    }
    end
  end
  # {
  #   :twitter=>"http://twitter.com/flatironschool",
  #   :linkedin=>"https://www.linkedin.com/in/flatironschool",
  #   :github=>"https://github.com/learn-co",
  #   :blog=>"http://flatironschool.com",
  #   :profile_quote=>"\"Forget safety. Live where you fear to live. Destroy your reputation. Be notorious.\" - Rumi",
  #   :bio=> "I'm a school"
  # }

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))


    links = build_link_hash(doc.css(".social-icon-container a"))
    links.merge({
                  profile_quote: doc.css(".profile-quote").text,
                  bio: doc.css(".bio-block .description-holder p").text,
                })
  end

  def self.build_link_hash(links)
    result = {}

    twitter_link = links.css("a[href*='twitter']")&.first
    if twitter_link
      result[:twitter] = twitter_link.attribute("href").text
      links.delete(twitter_link)
    end

    linkedin_link = links.css("a[href*='linkedin']")&.first
    if linkedin_link
      result[:linkedin] = linkedin_link.attribute("href").text
      links.delete(linkedin_link)
    end

    github_link = links.css("a[href*='github']")&.first
    if github_link
      result[:github] = github_link.attribute("href").text
      links.delete(github_link)
    end

    blog_link = links.css("a")
    result[:blog] = blog_link.attribute("href").text if blog_link.first

    result
  end

end
