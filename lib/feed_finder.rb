require 'net/http'
require 'net/https'
require 'json'

class FeedFinder
  UserAgent = 'iTunes/8.0.2 (Windows: U; Microsoft Windows XP Home Edition Service Pack 2 (Build 2600)) DPI/96'
  Uri = 'itunes.apple.com'
  Path = '/podcast/id/'

  def initialize(options={})
    if options
      if options[:url]
        @id = id_from_url(options[:url])
      end

      if options[:id]
        @id = options[:id]
      end
    end
  end

  def self.create!(options={})
    feed = self.new(options)
    feed.fetch!
    feed
  end

  def self.find(id)
    return nil if id.nil?

    http = Net::HTTP.new(Uri)
    req = Net::HTTP::Get.new("#{Path}#{id}", {"User-Agent" => UserAgent })
    response = http.request(req)
    lines = response.body.split("\n")
    feed_url = nil

    lines.each do |line|
      if line =~ /<key>feedURL<\/key><string\>(.*)<\/string>/
        url = $1
        if url =~ URI::regexp
          feed_url = url
        end
      end

      break if feed_url
    end
    feed_url 
  end

  def fetch!
    @feed_url = FeedFinder.find(@id)
  end

  def feed_url
    @feed_url ||= fetch!
    @feed_url ||= "Feed not found"
    @feed_url
  end

  def id_from_url(url)
    return $1 if url =~ /(id\d+)/
  end

  def path(id)
    "/podcast/id/#{id}"
  end

  def to_json(options={})
    {:feed_url => feed_url, :id => @id}.to_json(options)
  end
end
