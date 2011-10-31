module ChiefWhip
  class FormattingChecker
    ERR_INDENTATION    = "invalid indentation"
    ERR_LINE_ENDING    = "invalid line ending"
    ERR_TRAILING_SPACE = "trailing space"
    ERR_TAB            = "tab"

    def initialize(code)
      @lines = code.split(/\n/)
      validate
    end

    def valid?
      @errors.empty?
    end

    def errors
      @errors.sort
    end

  private
    def validate
      @errors = []
      validate_line_endings
      validate_trailing_space
      validate_tabs
      validate_indentation
    end

    def validate_line_endings
      validate_regexp %r{\r}, ERR_LINE_ENDING
    end

    def validate_trailing_space
      validate_regexp %r{ $}, ERR_TRAILING_SPACE
    end

    def validate_tabs
      validate_regexp %r{\t}, ERR_TAB
    end

    def validate_indentation
      if @lines.first =~ /^ /
        @errors << [1, ERR_INDENTATION]
      end
      indentation = @lines.map{ |s| s[/^ */].length }
      indentation.each_cons(2).with_index do |(prev, cur), i|
        if cur % 2 != 0 || cur > 2 && !indentation.include?(2)
          @errors << [i + 2, ERR_INDENTATION]
        end
      end
    end

    def validate_regexp(regexp, message)
      @lines.each_with_index do |cur, i|
        if cur =~ regexp
          @errors << [i + 1, message]
        end
      end
    end
  end
end
