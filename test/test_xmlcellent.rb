require 'helper'

class TestXmlcellent < Test::Unit::TestCase
  def test_should_create_a_new_parser_on_call_to_define_parser
    Xmlcellent::Parser.define_format :format_one
    assert Xmlcellent::Parser.singleton_methods.include? :parse_format_one
  end

  def test_define_parser_should_create_a_new_format_object
    Xmlcellent::Parser.define_format :format_two
    assert Xmlcellent::Parser.formats[:format_two].class == Xmlcellent::Format
  end

  def test_define_parser_should_add_new_format_to_formats_variable
    Xmlcellent::Parser.define_format :format_three
    assert Xmlcellent::Parser.formats.has_key? :format_three
  end

  def test_define_parser_should_raise_an_error_on_duplicate_key
    Xmlcellent::Parser.define_format :format_four
    assert_raise(RuntimeError) do
      Xmlcellent::Parser.define_format :format_four
    end
  end

end
