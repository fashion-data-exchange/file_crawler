require "bundler/setup"
require "fde/file_crawler"
require 'pry'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random
  Kernel.srand config.seed
end

FDE::FileCrawler.configure do |config|
  config.path_in_directory = './spec/fixtures/test_folder/in/'
  config.path_out_directory = './spec/fixtures/test_folder/out/'
end

