module ChiefWhip
  class CoverageParser
    def initialize(coverage)
      @coverage = coverage
    end

    def parse
      files = Hash.new { |h,k| h[k] = [] }
      @coverage.values.each do |run|
        run[:original_result].each do |filename, lines|
          files[filename] << lines
        end
      end
      Hash[files.map{ |file, runs|
        covered = runs.flat_map{ |run|
          run.map.with_index(1).
            select { |state, _| state != 0 }.
            map { |_, line| line }
        }.sort.uniq
        [file, covered]
      }]
    end
  end
end
