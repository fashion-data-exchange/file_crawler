require 'file_crawler/version'
require 'file_crawler/crawler'

module FDE

  module FileCrawler
    class Config
      attr_accessor :path_to_directory
    end

    def self.config
      @@config ||= Config.new
    end

    def self.configure
      yield self.config
    end
  end
end
