require "minitest/autorun"
require "chief_whip/coverage_parser"
require "yaml"

module ChiefWhip
  class CoverageParserTest < MiniTest::Unit::TestCase
    def setup
      coverage = YAML.load(File.read(File.expand_path("../data/coverage.yml", __FILE__)))
      @parser = CoverageParser.new(coverage)
    end

    def test_should_find_all_files_with_coverage_reports
      files = @parser.parse
      assert_equal %w[ /foo/bar.rb /foo/baz.rb /foo/quux.rb ], files.keys.sort
    end

    def test_should_include_lines_with_no_coverage_in_any_run
      lines = @parser.parse["/foo/bar.rb"]
      assert lines.include?(5), lines
    end

    def test_should_not_include_lines_with_coverage_in_only_one_run
      lines = @parser.parse["/foo/bar.rb"]
      assert !lines.include?(1), lines
    end

    def test_should_not_include_lines_with_coverage_in_more_than_one_run
      lines = @parser.parse["/foo/bar.rb"]
      assert !lines.include?(4), lines
    end

    def test_should_not_include_boring_lines
      lines = @parser.parse["/foo/bar.rb"]
      assert !lines.include?(3), lines
    end

    def test_should_include_lines_in_only_one_file
      lines = @parser.parse["/foo/baz.rb"]
      assert lines.include?(1), lines
    end
  end
end
