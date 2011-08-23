module Xmlcellent
  class Format
    attr_reader :finder
    attr_reader :lexicon

    def initialize(config)
      @finder  = config[:finder]
      @lexicon = config[:lexicon]
    end
  end
end
