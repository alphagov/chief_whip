require "minitest/autorun"
require "chief_whip/formatting"

module ChiefWhip
  class FormattingCheckerTest < MiniTest::Unit::TestCase

    def assert_invalid(sample)
      checker = FormattingChecker.new(sample)
      assert !checker.valid?
    end

    def assert_invalid(sample, reason)
      checker = FormattingChecker.new(sample)
      assert_equal reason, checker.reason
    end

    def quote(s)
      indent = s[/\A +/]
      s.gsub(/^#{indent}/, "")
    end

    def test_should_reject_code_using_windows_line_endings
      sample = %{class Foo\r\nend}
      checker = FormattingChecker.new(sample)
      assert !checker.valid?
      assert_equal [1, "invalid line ending"], checker.errors.first
    end

    def test_should_reject_code_using_tabs
      sample = quote <<-END
        class Foo
        \tdef bar
        \t\t"bar"
        \tend
        end
      END
      checker = FormattingChecker.new(sample)
      assert !checker.valid?
      assert_equal [2, "tab"], checker.errors.first
    end

    def test_should_reject_code_using_3_spaces_for_indentation
      sample = quote <<-END
        class Foo
           def bar
              "bar"
           end
        end
      END
      checker = FormattingChecker.new(sample)
      assert !checker.valid?
      assert_equal [2, "invalid indentation"], checker.errors.first
    end

    def test_should_reject_code_using_4_spaces_for_indentation
      sample = quote <<-END
        class Foo
            def bar
                "bar"
            end
        end
      END
      checker = FormattingChecker.new(sample)
      assert !checker.valid?
      assert_equal [2, "invalid indentation"], checker.errors.first
    end

    def test_should_reject_code_in_which_line_1_does_not_start_at_column_1
      sample = %{  class Foo\n  end}
      checker = FormattingChecker.new(sample)
      assert !checker.valid?
      assert_equal [1, "invalid indentation"], checker.errors.first
    end

    def test_should_accept_properly_indented_code
      sample = quote <<-END
        class Foo
          def bar
            "bar"
          end
        end
      END
      checker = FormattingChecker.new(sample)
      assert checker.valid?
      assert_equal [], checker.errors
    end

    def test_should_reject_trailing_spaces
      sample = %{class Foo \nend}
      checker = FormattingChecker.new(sample)
      assert !checker.valid?
      assert_equal [1, "trailing space"], checker.errors.first
    end
  end
end
