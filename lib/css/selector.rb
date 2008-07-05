module CSS
  class Selector
    attr_accessor :property
    attr_reader :name
    def initialize name, id_or_class, css, parent = nil, locals = {}
      parent_name = parent.name + " " if parent
      @locals = locals
      @name = "#{parent_name}#{name}#{id_or_class}"
      @property = {}
      @css = css

      metaclass = class << self; self; end
      metaclass.class_eval do
        locals.each_key do |key|
          attr_accessor key.to_sym
        end
      end

      locals.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def url str
      "url(#{str})"
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
          s = Selector.new '', id_or_class, @css, nil, @locals
        else
          s = Selector.new method_name, id_or_class, @css, self, @locals
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
end
