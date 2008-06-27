module CSS
  class Writer
    attr_accessor :selectors
    # +nodoc+ 
    def initialize
      @output = ""
      @selectors = {}
      @headers = []
    end

    # start a css dsl in a block
    def css &block
      instance_eval &block
      self
    end

    def header str
      @headers << str
    end

    def import path
      header "@import \"#{path}\";"
    end

    def any id_or_class = '', &block
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
        res << s.render(minified) unless s.property.size == 0
      end
      res
    end
  end
end
