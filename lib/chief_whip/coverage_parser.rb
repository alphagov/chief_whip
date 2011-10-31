module ChiefWhip
  class CoverageParser
    def initialize(coverage)
      @coverage = coverage
    end

    def parse
      files = Hash.new { |h,k| h[k] = [] }
      @coverage.values.each do |run|
        run[:original_result].each do |filename, lines|
          files[filename] = lines
        end
      end
      Hash[files.map{ |file, lines|
        uncovered = in_state(lines, 0)
        covered   = in_state(lines, 1)
        [file, uncovered - covered]
      }]
    end

  private
    def in_state(lines, n)
      lines.map.with_index.
        select { |state, _| state == n }.
        map { |_, line| line + 1}
    end
  end
end
