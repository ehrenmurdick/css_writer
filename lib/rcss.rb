require File.dirname(__FILE__) + '/selector.rb'
class Rcss
  attr_accessor :selectors
  def initialize
    @output = ""
    @selectors = {}
    @headers = []
  end

  def css &block
    instance_eval &block
  end

  def header str
    @headers << str
  end

  def import path
    header "@import \"#{path}\";"
  end

  def any id_or_class, &block
    if id_or_class.to_s == ''
      send("*", "", &block)
    else
      method_missing("", id_or_class, &block)
    end
  end

  def method_missing method_name, id_or_class = '', &block
    if id_or_class =~ /#/
      s = Selector.new '', id_or_class, self
    else
      s = Selector.new method_name, id_or_class, self
    end
    s = @selectors[s.name] if @selectors[s.name]
    s.instance_eval &block
    @selectors[s.name] = s
  end

  def render(minified = false)
    res = ""
    res << @headers.join("\n")
    res << "\n"
    @selectors.each_value do |s|
      res << s.render(minified)
    end
    res
  end
end
