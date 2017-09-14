require 'fde/file_crawler/version'

module FDE

  module FileCrawler
    class NoCopyTargetDefined < StandardError; end

    class Config
      attr_accessor :path_in_directory, :path_out_directory
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
      path = self.config.path_in_directory
      files = Dir.entries(path)
      files -=  %w[. ..]
      files.select { |file| query.match(file) }
    end

    def self.copy(file, target = nil)
      if self.config.path_out_directory && target.nil?
        FileUtils.copy(path_for(file), self.config.path_out_directory)
      elsif target.nil?
        raise NoCopyTargetDefined
      else
        FileUtils.copy(path_for(file), target)
      end
    end

    def self.delete(file)
      FileUtils.rm(path_for(file))
    end

    def self.move(file, target)
      FileUtils.mv(path_for(file), target)
    end

    def self.path_for(file)
      "#{self.config.path_in_directory}#{file}"
    end
  end
end
