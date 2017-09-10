require "spec_helper"

RSpec.describe FDE::FileCrawler do
  it "has a version number" do
    expect(FDE::FileCrawler::VERSION).not_to be nil
  end

  let(:path_to_directory) { "./spec/fixtures/test_folder/" }

  context 'configuration' do
    it 'is of Type FDE::FileCrawler::Config' do
      expect(subject.config).to be_a(FDE::FileCrawler::Config)
    end

    it 'yields the config block' do
      expect do |b|
        subject.configure(&b)
      end.to yield_with_args
    end

    it 'should have a configured path_to_directory' do
      expect(subject.config.path_to_directory).to eq(path_to_directory)
    end

  end

  context 'crawl' do
    let(:files) { %w(.rspec_status doc.md text.txt) }
    let(:markdowns) { ["doc.md"] }
    let(:texts) { ["text.txt"] }

    before do
      subject.config.path_to_directory = path_to_directory
    end

    it 'should return an array of files' do
      expect(FDE::FileCrawler.crawl).to eq(files)
    end

    it 'should filter the files by a .txt files' do
      expect(FDE::FileCrawler.crawl(/.*.\.txt/i)).to eq(texts)
    end

    it 'should filter the files by a .md files' do
      expect(FDE::FileCrawler.crawl(/.*.\.md/i)).to eq(markdowns)
    end
  end

end
