module Xmlcellent
  class Parser
    class << self
      attr_accessor :formats

      def define_format(name)
        @formats ||= {}
        raise "Format already exists!" if @formats.has_key? name
        @formats[name] = Format.new

        singleton = class << self; self; end
        singleton.instance_eval do
          define_method("parse_#{name.to_s}".to_sym) do
            # method here
          end
        end
      end
    end
  end
end
