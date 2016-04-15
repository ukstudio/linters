require "spec_helper"
require "scss_lint/file"

describe ScssLint::File do
  describe ".in_tmpdir" do
    it "writes each file into the tmpdir and yields the dir" do
      file_one = ScssLint::File.new("file-one.scss", "some content")
      file_two = ScssLint::File.new("file-two.scss", "some content")

      ScssLint::File.in_tmpdir(file_one, file_two) do |dir|
        expect(Dir.entries(dir)).to include("file-one.scss", "file-two.scss")
      end
    end
  end

  describe "#write_to_dir" do
    it "writes files in the given directory" do
      Dir.mktmpdir do |dir|
        file = ScssLint::File.new("file.scss", "")

        file.write_to_dir(dir)

        expect(Dir.entries(dir)).to include("file.scss")
      end
    end
  end
end
