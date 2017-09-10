module FDE
  module FileCrawler
    def self.crawl(query = /.*\.*/i)
      path = self.config.path_to_directory
      files = Dir.entries(path)
      files -=  %w[. ..]
      files.select { |file| query.match(file) }
    end
  end
end
