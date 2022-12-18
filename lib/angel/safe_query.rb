class SafeQuery

  attr_accessor :model_name, :methods, :permissions

  def initialize(**args)
    self.permissions = {allow:{}, prevent:{}}
    if(!!args[:model_name] && args[:model_name].classify.constantize.ancestors.include?(ActiveRecord::Base))
      self.model_name = args[:model_name]
      binding.pry
      self.allow("all", for_type:"Class")
      self.allow("first", for_type:"ActiveRecord::Relation")
    end
    if(!!args[:methods])
      if(!args[:methods].is_a?(Array))
        self.methods = [args[:methods]]
      else
        self.methods = args[:methods]
      end
    else
      self.methods = []
    end
  end

  def model
    return self.model_name.classify.constantize
  end

  def result_type(index=methods.length)
    current_result = self.call(to:index)
    result = current_result.class.name
    if(result == "Class")
      if(current_result.ancestors.include?(ActiveRecord::Base))
        return "Model:#{current_result.name}"
      else
        return "#{current_result.superclass}"
      end

    elsif(["Array","ActiveRecord::Relation"].include?(result))
      result = result
      if(current_result.first.class.ancestors.include?(ActiveRecord::Base))
        return "#{result}(Model:#{current_result.name})"
      end
    else
      return result
    end
  end

  def get_type(m, index=nil)
    if(!%I[delete destroy].include?(m.to_sym))
      current_result = call(to:index)
      begin
        result = current_result.try(m).class.name
      rescue => e
      end
    end
  end

  def call(**args)
    result = self.model
    if(!!args[:to])
      i = 0
      if(args[:to] == 0)
        return result
      elsif(args[:to] <= self.methods.length)
        self.methods[0,args[:to]].each do |m|
          current_type = result.class.name
          if(self.permissions[:allow][current_type].any?{|rx| m[:method].match?(rx)})
            if(!!m[:args])
              result = result.send(m[:method],**m[:args])
            else
              result = result.send(m[:method])
            end
          else
            raise Exception.new "#{m[:method]} is not a permitted call for #{result} (#{current_type}) ."
          end
        end
      end
      return result
    else
      self.methods.each do |m|
        current_type = result.class.name
        if(self.permissions[:allow][current_type].any?{|rx| m[:method].match?(rx)})
          if(!!m[:args])
            result = result.send(m[:method],**m[:args])
          else
            result = result.send(m[:method])
          end
        else
          raise Exception.new "#{m[:method]} is not a permitted call for #{result} (#{current_type}) ."
        end
      end
      return result
    end
  end

  private
  def allow(target,**args)
    permissions[:allow][target] ||= []
    if(!!args[:for_type])
      target = args[:for_type]
    end
    if(!!args[:method_selector] && !args[:method_selector].is_a?(Regexp))
      method_selector = Regexp.new(args[:method_selector])
      permissions[:allow][target] << {methods_matching:method_selector}
    elsif(!!args[:target_type])
      permissions[:allow][target] << {return_type:method_selector}
    end
  end
  def prevent(target,**args)
    permissions[:prevent][target] ||= []
    if(!!args[:for_type])
      target = args[:for_type]
    end
    if(!!args[:method_selector] && !args[:method_selector].is_a?(Regexp))
      method_selector = Regexp.new(args[:method_selector])
      permissions[:prevent][target] << {methods_matching:method_selector}
    elsif(!!args[:target_type])
      permissions[:prevent][target] << {return_type:method_selector}
    end
  end
end
