require 'helper'

class Item
  attr_accessor :name
  attr_accessor :summary
end

class TestXmlcellent < Test::Unit::TestCase
  def setup
    @xml ||= <<-END
      <items>
        <item>
          <name>Item one</name>
          <description color="red">Lorem ipsum dolor</description>
          <summary>
            <paragraph>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.</paragraph>
            <paragraph>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.</paragraph>
            <paragraph>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.</paragraph>
          </summary>
        </item>
        <item>
          <name>Item two</name>
          <description color="blue">Lorem ipsum dolor</description>
          <summary>
            <paragraph>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.</paragraph>
            <paragraph>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.</paragraph>
            <paragraph>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.</paragraph>
          </summary>
        </item>
        <item>
          <name>Item three</name>
          <description color="yellow">Lorem ipsum dolor</description>
          <summary>
            <paragraph>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.</paragraph>
            <paragraph>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.</paragraph>
            <paragraph>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.</paragraph>
          </summary>
        </item>

    END
  end
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

  def test_should_parse_xml_when_passed_a_string_of_xml
    Xmlcellent::Parser.define_format :format_five, Item, {
      :finder => "//item",
      :lexicon => {
        :name => "name"
      }
    }
    result = Xmlcellent::Parser.parse_format_five(@xml)
    assert_equal result.length, 3
    assert_equal result[0].name, "Item one"
  end

  def test_should_parse_xml_by_applying_a_lambda
    Xmlcellent::Parser.define_format :format_six, Item, {
      :finder => "//item",
      :lexicon => {
        :summary => lambda { |obj|
          obj.xpath("summary/paragraph").inject("") { |c, p| c + p.text }
        }
      }
    }
    result = Xmlcellent::Parser.parse_format_six(@xml)
    assert_equal result[0].summary.scan(/Lorem/).length, 3
  end

end
