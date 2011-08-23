module Xmlcellent
  class Format
    attr_reader :finder, :lexicon

    def initialize(config)
      @finder  = config[:finder]
      @lexicon = config[:lexicon]
    end
  end
end
