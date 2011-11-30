require "minitest/autorun"
require "chief_whip/blame_parser"

module ChiefWhip
  class BlameParserTest < MiniTest::Unit::TestCase
    def setup
      blame = File.read(File.expand_path("../data/blame", __FILE__))
      @parser = BlameParser.new(blame)
    end

    def test_should_extract_single_name
      lines = @parser.parse
      assert_equal "Alice", lines[1].name
    end

    def test_should_extract_name_with_space
      lines = @parser.parse
      assert_equal "Bob Bob", lines[2].name
    end

    def test_should_extract_commit
      lines = @parser.parse
      assert_equal "abcd0003", lines[3].commit
    end
  end
end
