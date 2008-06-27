require 'lib/css_writer'
require 'test/unit'

class TestCssWriter < Test::Unit::TestCase
  def setup
    @writer = CSS::Writer.new
  end
  
  def test_should_hyphenate_camel_case_method_names_for_attributes
    @writer.css do
      body do
        backgroundImage 'image'
      end
    end
    assert_match /background-image/, @writer.render
  end

  def test_should_drop_tag_name_when_using_an_id
    @writer.css do
      div '#an_id' do
        foo 'bar'
      end
    end
    assert_match /^#an_id/, @writer.render
  end

  def test_should_use_an_asterisk_when_any_is_called_with_no_id_or_class
    @writer.css do
      any do
        foo 'bar'
      end
    end
    assert_match /\*/, @writer.render
  end

  def test_should_use_only_id_or_class_when_any_is_called_with_an_argument
    @writer.css do
      any '.class' do
        foo 'bar'
      end
    end
    assert_match /^\.class/, @writer.render
  end

  def test_should_not_nest_or_use_tag_name_for_tags_which_use_id
    @writer.css do
      div do
        div '#an_id' do
          foo 'bar'
        end
      end
    end
    assert_match /^#an_id/, @writer.render
  end

  def test_should_nest_tags
    @writer.css do
      body do
        div do
          foo 'bar'
        end
      end
    end
    assert_match /^body div/, @writer.render
  end

  def test_should_not_render_empty_tags
    @writer.css do
      body do
        div do
          color 'red'
        end
      end
    end
    assert_no_match /^body \{/, @writer.render
  end
end
