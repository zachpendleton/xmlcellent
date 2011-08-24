require "nokogiri"

module Xmlcellent
  # A shortcut method for Xmlcellent::Parser.parse()
  def self.parse(doc)
    Parser.parse(doc)
  end

  # Handles the parsing of XML data using Xmlcellent::Format
  # objects.
  class Parser
    class << self
      attr_accessor :formats

      # Erases all existing formats
      def delete_formats!
        @formats = {}
      end

      # Given a string of XML, this method loops through the
      # defined Formats and, if it finds a match, calls that
      # method to parse the XML into objects.
      def parse(doc)
        document = Nokogiri::XML(doc).remove_namespaces!
        @formats.each do |key, format|
          if document.xpath(format.finder).length > 0
            return self.send("parse_#{key}".to_sym, doc)
          end
        end
        raise "Error: Parser not found!"
      end

      # Creates a format on the Xmlcellent::Parser object to
      # be used to convert XML to models.
      def define_format(name, model = nil, config = {})
        @formats ||= {}
        raise "Format already exists!" if @formats.has_key? name
        @formats[name] = Format.new(config)

        # This ugly piece of code is used to dynamically generate
        # class methods in a way that Ruby 1.8 understands.
        singleton = class << self; self; end
        singleton.instance_eval do
          define_method("parse_#{name.to_s}".to_sym) do |doc|
            document = doc.class == Nokogiri::XML::Document ?
              doc :
              Nokogiri::XML(doc).remove_namespaces!
            results  = []

            document.xpath(@formats[name].finder).each do |obj|
              m = model.new
              @formats[name].lexicon.each do |key, path|
                next if path.nil? # fail silently if given a bad path

                value = path.class == Proc ? path.call(obj) : obj.xpath(path).text
                m.send("#{key.to_s}=".to_sym, value)
              end
              results << m
            end
            results
          end
        end
      end
    end
  end
end
