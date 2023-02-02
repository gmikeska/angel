module Angel
  class Options
    attr_accessor :scope, :design, :scope_name
    delegate :settings_scopes, to: :design
    delegate :to_json, to: :to_h

    def initialize(**args)
      if(!!args[:design])
        @design = args[:design]
        @settings_scopes = {}
      end
      @scope = args[:scope]
      if(!!args[:scope] && !args[:scope_name])
        @scope_name = args[:scope].class.name.parameterize.to_sym
      elsif(!!args[:scope_name])
        @scope_name = args[:scope_name]
      end

    end

    def defaults
      return (self.design.defaults[@scope_name] || {})
    end

    def settings_scope_names
      @settings_scopes.symbolize_keys.keys
    end



    def reset_scope_settings(scope_name)
      if(self.is_root? && !!@settings_scopes[scope_name])
        configure_scope(scope_name,self.defaults[scope_name])
        @settings_scopes[scope_name].reload()
      end
    end

    def settings
      defaults = self.defaults
      # binding.pry
      settings_data = @scope.design_settings(self.design.config_key)
      defaults.each do |key, data|
        if(!settings_data[key])
          settings_data[key] = data
        else
          data[:value].each do |k, v|
            if(!settings_data[key][:value][k])
              settings_data[key][:value][k] = v
            end
          end
        end
      end
      return settings_data
    end

    def get_setting(key)
       self.settings[key]
    end

    def keys
      return self.settings.keys.concat(self.defaults.keys).uniq
    end

    def [](key)
      if(self.is_default?(key))
        return self.defaults[key]
      else
        return get_setting(key)
      end
    end

    def []=(key, val)
      data = @scope.design_settings(self.design.config_key)
      data[key] = val
      @scope.set_design_settings(self.design.config_key, data)
    end

    def is_default?(key)
      data = @scope.design_settings(self.design.config_key)[key]
      return (! data || self.defaults[key] == self[key])
    end

    def to_h
      if(self.is_root?)
        return {parent:self.design, scopes:@settings_scopes.map{|n,s| return [n, s.to_h] }.to_h }
      else
        return {scope_model:@scope.class.name, scope_param:@scope.to_param}
      end
    end
  end
end
