class CustomizableTag
  include ActionView::Helpers::TagHelper
  attr_accessor :functional_class, :css_class, :css_id

  def initialize(**args)
    @args = args
    if(!!@args[:content])
      @content = @args[:content]
      @args.delete(:content)
    end
    if(!!@args[:class])
      @css_class = @args[:class]
      @args.delete(:class)
    else
      @css_class = ""
    end
    if(!!@args[:functional_class])
      @functional_class = @args[:functional_class]
    else
      @functional_class = ""
    end
  end
  def set(arg_name, value)
    @args[arg_name.to_sym] = value
  end
  def []=(arg,value)
    self.set(arg,value)
  end
  def add_class(new_class)
    @css_class << new_class
  end
  def remove_class(removed_class)
    @css_class.delete(removed_class)
  end
  def build(&block)
    opts = @args.select{|k,v| k != :tag_name}.map{|k,v| [k,v]}.to_h
    if(!@functional_class)
      @functional_class = ""
    end
    if(!@css_class)
      @css_class = ""
    end
    classes = @functional_class.split(" ").concat(@css_class.split(" ")).map{|s| s.lstrip.rstrip}.uniq.select{|s| s!=""}

    opts[:class] = classes.join(" ") if(classes.any?)

    if(!!@args[:css_id])
      opts[:id] = @args[:css_id]
    end
    if(block_given?)
      block_content = capture(configs, &block).to_s.html_safe
      self.content_tag(@args[:tag_name], block_content,opts)
    else
      self.content_tag(@args[:tag_name], @content,opts)
    end
  end
  def method_missing(m, value=nil)
    # binding.pryf
    if(!m.to_s.ends_with?("=") && !!@args[m])
      return @args[m]
    elsif(m.to_s.ends_with?("="))
      self.set(m.to_s.match(/(\w*)=/)[1].to_sym,value)
    end
  end
end
