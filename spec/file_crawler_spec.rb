require "spec_helper"

RSpec.describe FDE::FileCrawler do
  it "has a version number" do
    expect(FDE::FileCrawler::VERSION).not_to be nil
  end

  let(:path_in_directory) { "./spec/fixtures/test_folder/in/" }
  let(:path_out_directory) { "./spec/fixtures/test_folder/out/" }

  context 'configuration' do
    it 'is of Type FDE::FileCrawler::Config' do
      expect(subject.config).to be_a(FDE::FileCrawler::Config)
    end

    it 'yields the config block' do
      expect do |b|
        subject.configure(&b)
      end.to yield_with_args
    end

    it 'should have a configured path_in_directory' do
      expect(subject.config.path_in_directory).to eq(path_in_directory)
    end

    it 'should have a configured path_out_directory' do
      expect(subject.config.path_out_directory).to eq(path_out_directory)
    end

  end

  context 'crawl' do
    let(:markdowns) { "doc.md" }
    let(:texts) { "text.txt" }

    before do
      subject.config.path_in_directory = path_in_directory
      subject.config.path_out_directory = path_out_directory
    end

    it 'should return an array of files' do
      expect(FDE::FileCrawler.crawl).to include(markdowns)
      expect(FDE::FileCrawler.crawl).to include(texts)
    end

    it 'should filter the files by a .txt files' do
      expect(FDE::FileCrawler.crawl(/.*.\.txt/i)).to include(texts)
    end

    it 'should filter the files by a .md files' do
      expect(FDE::FileCrawler.crawl(/.*.\.md/i)).to include(markdowns)
    end
  end

  context 'path_for' do
    let(:file) { 'text.txt' }

    it 'should return the path for a file' do
      expect(subject.path_for(file)).to eq("#{path_in_directory}#{file}")
    end
  end

  context 'copy' do
    let(:text_file) { 'text.txt' }
    let(:new_file_name) { 'test2.txt' }
    let(:path) { "#{path_in_directory}new_folder/" }

    context 'with a target given' do
      it 'should copy a file' do
        subject.copy(text_file, "#{path}#{new_file_name}")
        expect(File).to exist("#{path}#{new_file_name}")
      end

      after do
        FileUtils.rm("#{path}#{new_file_name}")
      end
    end

    context 'with no target given' do
      it 'should copy a file to the out dir' do
        subject.copy(text_file)
        expect(File).to exist("#{path_out_directory}#{text_file}")
      end

      after do
        FileUtils.rm("#{path_out_directory}#{text_file}")
      end
    end

    context 'with no target and no out dir' do
      before do
        subject.config.path_out_directory = nil
      end

      it 'should raise an error' do
        expect{ subject.copy(text_file) }.to raise_error(
          FDE::FileCrawler::NoCopyTargetDefined
        )
      end

      after do
        subject.config.path_out_directory = path_out_directory
      end
    end
  end

  context 'delete' do
    let(:text_file) { "text.txt" }
    let(:new_file_name) { "text2.txt" }

    before :each do
      subject.copy(text_file, subject.path_for(new_file_name))
    end

    it 'should delete a file' do
      expect(File).to exist("#{path_in_directory}#{new_file_name}")
      subject.delete(new_file_name)
      expect(File).to_not exist("#{path_in_directory}#{new_file_name}")
    end
  end

  context 'watch' do
    def dummy_method(file)
      "I am the file #{file}"
    end

    it 'calls the watch block' do
      expect do |b|
        subject.watch(&b)
      end.to yield_with_args
    end

    it 'calls the dummy_method' do
      subject.watch do |files|
        files.each do |file|
          expect(dummy_method(file)).to eq("I am the file #{file}")
        end
      end
    end
  end

end
