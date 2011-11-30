module ChiefWhip
  Blame = Struct.new(:commit, :name)  

  class BlameParser
    def initialize(source)
      @source = source
    end

    def parse
      Hash[
        @source.scan(/^(\S+) \((.*?) \d{4}-\d{2}-\d{2}/).map.with_index(1) { |r, i|
          [i, Blame.new(*r)]
        }
      ]
    end
  end
end
