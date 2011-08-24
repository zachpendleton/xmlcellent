module Xmlcellent
  # Given a hash with a :finder key and a
  # :lexicon key, this model stores config
  # information for a parser.
  class Format
    attr_reader :finder, :lexicon

    def initialize(config)
      @finder  = config[:finder]
      @lexicon = config[:lexicon]
    end
  end
end
