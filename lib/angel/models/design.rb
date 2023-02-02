module Angel
  class Design < Base
    include SupportsPointer
    include DesignSettingsMethods
    serialize :options_data
    serialize :defaults_data
    delegate :params, to: :component
    belongs_to :page, optional: true
    attr_accessor :settings_scopes

    before_save do |design|
      if(!!design.name && !design.slug)
        design.slug = design.name.parameterize.underscore
      end
    end

    after_initialize do |design|
      if(!design.options_data)
        design.options_data = {}
        design.save
      end
      if(!design.settings_scopes)
        design.settings_scopes =  {}
        design.save
      end
      if(!!design.defaults && !!design.defaults.keys && design.has_settings_scope?(:global))
        design.settings_scope(:global, design)
      end
    end


    def self.type_of(target)
      result = target.class.name
      if(result == "Class")
        if(o.ancestors.include?(ActiveRecord::Base))
          return "Model:#{target.name}"
        else
          return "#{target.superclass}"
        end

      elsif(["Array","ActiveRecord::Relation"].include?(result))
        result = result
        if(target.first.class.ancestors.include?(ActiveRecord::Base))
          return "#{result}(Model:#{target.first.name})"
        else
          return "#{result}(#{target.first.class.name})"
        end
      else
        return result
      end
    end

    # Creates the component instance object using data options from the database
    # @param args [Hash] the hash of component options to be passed to the component's :new method
    # @return an instance of the design's component
    def component(**args)
      o = self.options
      if(!!o[:query])
        o[:records] = self.query
        o.delete(:query)
      end
      args[:edit_path] = "/designs/#{self.id}/component/edit"
      o = o.merge(args)
      if(!o[:css_id])
        raise Exception.new "options[:css_id] is required to render the #{self.component_name}Component #{self.name}"
      end
      @component ||= (self.component_name.classify+"Component").constantize.new(**o)
      @component.design = self
      @component.id = o[:css_id]
      return @component
    end

    def settings_scope_names
      @settings_scopes.keys
    end

    def settings_scope(scope_name, scope_model)
      @settings_scopes[scope_name] = Angel::Options.new(design:self, scope:scope_model, scope_name:scope_name)
    end


    # Creates an instance of the component's loader (turbo-frame components only)
    # @param data [Hash] the hash of component options to be passed to the component's :new method
    # @return an instance of the component's loader
    def loader(**data)
      if(!self.configured?)
        throw Exception "Trying to build a component that is not configured."
      end
      if(!data[:css_id])
        data[:id] = self.options[:css_id]
      end

      if(data[:path])
        path = data[:path]
        data.delete(:path)
      else
        # if(!!self.page)
        #   path = "/pages/#{self.page.id}/designs/#{self.id}/component"
        # else
          path = "/designs/#{self.id}/component"
        # end
      end

      self.component(**data).loader(path).html_safe
    end

    # Sets the design's query option
    # @param query_params [Array] the value to set for the query option
    # @return [Boolean] true if the query was saved, false otherwise
    def query=(query_params)
      o = self.options
      if(!o[:query])
        o[:query] = query_params
      end
      self.options = o
      self.save
    end

    def configured?
      result = true
      if(!self.component_name)
        result = false
        puts "-------------------------------------------"
        puts "component_name needed for #{self.name}"
        puts "-------------------------------------------"
      end
      if(!self.options || !self.options[:css_id])
        puts "------------------------------------------------------------------"
        puts "WARNING:options[:css_id] needed to render component for #{self.name}."
        puts "this can be passed in Design init, set after initialization"
        puts "or can be passed during calls to 'design_#{self.name}.loader'"
        puts "------------------------------------------------------------------"
      end
      return result
    end
    # Performs the design's query against its target
    # @return the query result
    def query
      if(!!options[:query])
        model = options[:query][0].classify.constantize
        scope = options[:query][1].to_sym
        if(!!options[:query][2])
          params = options[:query][2]
          return model.send(scope, **params)
        else
          return model.send(scope)
        end
      end
    end

    # Returns a key used to index settings for this design
    # @return [String] the design's config_key
    def config_key
      if(!!self.page)
        "#{self.page.controller}_#{self.page.action}.#{self.name}"
      else
        "components.#{self.name}"
      end
    end

    # Returns the params for the design's controller
    # @return [Hash] the component's params
    def params
      component.class.params
    end

    # Deserializes design's options
    # @return [Hash] the design's options
    def options(selection=nil)
      return self.options_data.symbolize_keys
    end

    # Serializes hash into design's options column
    # @param data [Hash] the options data to be stored
    # @return [Hash] the data passed in
    def options=(data)
      self.options_data = data
    end

    # Returns design's user option defaults
    # @return [Hash] the design's user option defaults
    def settings
      data = {}
      self.settings_scope_names.reverse.each do |scope_name|
        scope_data = self.settings_scopes[scope_name].settings
        data = data.merge(scope_data)
      end
      return data
    end

    def design_settings(design_key=nil)
      self.options[:settings] || {}

    end

    def set_design_settings(design_key, data)
      self.options[:settings] = data
      self.save
    end

    def reset_scope_settings(scope_name)
      if(!! @settings_scopes[scope_name])
        configure_scope(scope_name,self.defaults[scope_name])
        @settings_scopes[scope_name].reload()
      end
    end

    def configure_scope(scope_name, data)
      # binding.pry
      self.settings_scopes[scope_name].scope.set_design_settings(config_key, data)
      @settings_scopes[scope_name].scope.save
    end

    # Returns design's form path
    # @return [String] the path to the design's form
    def user_edit_url
      "/designs/#{self.id}/component/edit"
    end

    # If @user is set, returns @user's options for this design
    # otherwise, returns the design's default options.
    # @return [Hash] the user_options hash
    def user_options
      if(!!settings_scopes[:user] && settings_scopes[:user].design_settings(config_key) == {})
          settings_scopes[:user].set_design_settings(config_key,settings)
          settings_scopes[:user].save
          return settings.symbolize_keys
      elsif(!!settings_scopes[:user])
          return settings.symbolize_keys
      end
    end

    # If @user is set, stores the given data as
    # the user's settings for this design.
    def user_options=(data)

      if(!!settings_scopes[:user])
        settings_scopes[:user].set_design_settings(config_key, data)
        settings_scopes[:user].save
      end
    end

    def defaults
      return options.symbolize_keys[:defaults]
    end
    # set the defaults for all settings_scopes with a single call
    def has_settings_scope?(scope_name)
      self.defaults.has_key?(scope_name)
    end

    def set_defaults(data)
      o = self.options
      o[:defaults] = data
      self.options = o
      self.save
    end

    # set the defaults for a specific settings scope
    def set_scope_defaults(scope_name,data)
      o = self.options
      o[:defaults] = {} if(!o[:defaults])
      o[:defaults][scope_name] = data
      self.options = o
      self.save
    end

    def scope_defaults(scope_name)
      self.options[:defaults][scope_name]
    end

    # def method_missing(m,**args, &block)
    #   if(m.to_s.starts_with?("with_") && self.component.respond_to?(m.to_sym))
    #     slot_name = m.to_s.match(/with_(?<slot_name>\w*)/)["slot_name"]
    #     o = self.options
    #     if(!o[:slots])
    #       o[:slots] = {}
    #     end
    #     o[:slots][slot_name.to_sym] = block.to_proc
    #     self.options = o
    #     self.save
    #   end
    # end
  end
end
