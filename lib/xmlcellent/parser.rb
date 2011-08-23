require "nokogiri"

module Xmlcellent
  class Parser
    class << self
      attr_accessor :formats

      def define_format(name, model = nil, config = {})
        @formats ||= {}
        raise "Format already exists!" if @formats.has_key? name
        @formats[name] = Format.new(config)

        singleton = class << self; self; end
        singleton.instance_eval do
          define_method("parse_#{name.to_s}".to_sym) do |doc|
            document = Nokogiri::XML(doc).remove_namespaces!
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
