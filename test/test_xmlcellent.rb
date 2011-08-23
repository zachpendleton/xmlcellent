require 'helper'

class Item
  attr_accessor :name
  attr_accessor :summary
  attr_accessor :color
  attr_accessor :supplier
end

class TestXmlcellent < Test::Unit::TestCase
  def setup
    @xml ||= <<-END
      <items>
        <item supplier="Dunder Mifflin">
          <name>Item one</name>
          <description color="red">Lorem ipsum dolor</description>
          <summary>
            <paragraph>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.</paragraph>
            <paragraph>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.</paragraph>
            <paragraph>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.</paragraph>
          </summary>
        </item>
        <item supplier="Plainview Medical">
          <name>Item two</name>
          <description color="blue">Lorem ipsum dolor</description>
          <summary>
            <paragraph>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.</paragraph>
            <paragraph>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.</paragraph>
            <paragraph>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.</paragraph>
          </summary>
        </item>
        <item supplier="Bluth Company">
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
    Xmlcellent::Parser.define_format :test_format
    assert Xmlcellent::Parser.singleton_methods.include? :parse_test_format
  end

  def test_define_parser_should_create_a_new_format_object
    Xmlcellent::Parser.define_format :test_format
    assert Xmlcellent::Parser.formats[:test_format].class == Xmlcellent::Format
  end

  def test_define_parser_should_add_new_format_to_formats_variable
    Xmlcellent::Parser.define_format :test_format
    assert Xmlcellent::Parser.formats.has_key? :test_format
  end

  def test_define_parser_should_raise_an_error_on_duplicate_key
    Xmlcellent::Parser.define_format :test_format
    assert_raise(RuntimeError) do
      Xmlcellent::Parser.define_format :test_format
    end
  end

  def test_should_parse_xml_when_passed_a_string_of_xml
    Xmlcellent::Parser.define_format :test_format, Item, {
      :finder => "//item",
      :lexicon => {
        :name => "name"
      }
    }
    result = Xmlcellent::Parser.parse_test_format(@xml)
    assert_equal result.length, 3
    assert_equal result[0].name, "Item one"
  end

  def test_should_parse_xml_by_applying_a_lambda
    Xmlcellent::Parser.define_format :test_format, Item, {
      :finder => "//item",
      :lexicon => {
        :summary => lambda { |obj|
          obj.xpath("summary/paragraph").inject("") { |c, p| c + p.text }
        }
      }
    }
    result = Xmlcellent::Parser.parse_test_format(@xml)
    assert_equal result[0].summary.scan(/Lorem/).length, 3
  end

  def test_should_parse_xml_by_reading_attributes
    Xmlcellent::Parser.define_format :test_format, Item, {
      :finder => "//item",
      :lexicon => {
        :color => "description/@color",
        :supplier => "@supplier"
      }
    }

    result = Xmlcellent::Parser.parse_test_format(@xml)
    assert_equal result[0].color, "red"
    assert_equal result[0].supplier, "Dunder Mifflin"
  end

  def test_should_delete_all_formats_on_call_to_delete_formats
    Xmlcellent::Parser.define_format :test_format, Item, {}
    Xmlcellent::Parser.delete_formats!
    assert_equal Xmlcellent::Parser.formats.length, 0
  end

  def teardown
    Xmlcellent::Parser.delete_formats!
  end
end
