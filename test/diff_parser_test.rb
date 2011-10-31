require "minitest/autorun"
require "chief_whip/diff_parser"

module ChiefWhip
  class DiffParserTest < MiniTest::Unit::TestCase
    def setup
      diff = File.read(File.expand_path("../data/diff", __FILE__))
      @parser = DiffParser.new(diff)
    end

    def test_should_extract_filenames
      files = @parser.parse
      assert_equal %w[ foo/bar.txt foo/baz.txt ], files.keys.sort
    end

    def test_should_extract_one_set_of_lines
      files = @parser.parse
      expected = {
        21 => "    NEWLINE21"
      }
      assert_equal expected, files["foo/baz.txt"]
    end

    def test_should_extract_multiple_sets_of_lines
      files = @parser.parse
      expected = {
          4 => "    NEWLINE04",
          5 => "    NEWLINE05",
          9 => "NEWLINE11",
        217 => "    NEWLINE202"
      }
      assert_equal expected, files["foo/bar.txt"]
    end
  end
end
