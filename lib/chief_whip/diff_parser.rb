module ChiefWhip
  class DiffParser
    def initialize(diff)
      @diff = diff
    end

    def parse
      files = {}
      file, offset = nil
      @diff.split(/\n/).each do |line|
        case line
        when %r{^diff}
          file = {}
        when %r{^index|^---}
          # re
        when %r{\+\+\+ [^/]+/(.*)}
          files[$1] = file
        when %r{^@@ -\d+,\d+ \+(\d+),\d+}
          offset = $1.to_i
        when %r{^ .*}
          offset += 1
        when %r{^\+(.*)}
          file[offset] = $1
          offset += 1
        end
      end

      files
    end
  end
end
