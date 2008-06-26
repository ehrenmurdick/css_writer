class Selector
  attr_accessor :property
  attr_reader :name
  def initialize name, id_or_class, css, parent = nil
    parent_name = parent.name + " " if parent
    @name = "#{parent_name}#{name}#{id_or_class}"
    @property = {}
    @css = css
  end

  def any id_or_class = '', &block
    if id_or_class.to_s == ''
      send("*", "", &block)
    else
      method_missing("", id_or_class, &block)
    end
  end

  def method_missing method_name, id_or_class = '', &block
    if block_given? 
      if id_or_class =~ /#/
        s = Selector.new '', id_or_class, @css, nil
      else
        s = Selector.new method_name, id_or_class, @css, self
      end
      s = @css.selectors[s.name] if @css.selectors[s.name] 
      s.instance_eval &block
      @css.selectors[s.name] = s
    else
      p = method_name.to_s.gsub(/[A-Z]/) do |match|
        "-#{match.downcase}"
      end
      @property[p] = id_or_class
    end
  end

  def []=(key, value)
    @property[key] = value
  end

  def render(minified = false)
    if minified
      res = "#{name}{"
      @property.each do |key, value|
        res << "#{key}:#{value};"
      end
      res << "}"
    else 
      res = "#{name} {\n"
      @property.each do |key, value|
        res << "  #{key}: #{value};\n"
      end
      res << "}\n"
    end
  end
end


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
