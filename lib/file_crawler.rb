require 'file_crawler/version'

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

    def self.watch(query = nil, &block)
      unless query.nil?
        yield self.crawl(query)
      else
        yield self.crawl
      end
    end

    def self.crawl(query = /.*\.*/i)
      path = self.config.path_to_directory
      files = Dir.entries(path)
      files -=  %w[. ..]
      files.select { |file| query.match(file) }
    end

    def self.copy(file, target)
      FileUtils.copy(path_for(file), target)
    end

    def self.delete(file)
      FileUtils.rm(path_for(file))
    end

    def self.move(file, target)
      FileUtils.mv(path_for(file), target)
    end

    def self.path_for(file)
      "#{self.config.path_to_directory}#{file}"
    end
  end
end
