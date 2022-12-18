module Angel
  class Design < Base
    include SupportsPointer
    serialize :options_data
    serialize :settings_data
    serialize :defaults_data
    belongs_to :page, optional: true
    attr_accessor :user
    before_save do |design|
      if(!!design.name)
        design.slug = design.name.parameterize.underscore
      end
    end

    after_initialize do |design|
      design.defaults = design.options
      design.save
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
      if(!!options[:query])
        o[:records] = self.query
        o.delete(:query)
      end
      args[:edit_path] = user_edit_url
      o = o.merge(args)
      @component ||= (self.component_name.classify+"Component").constantize.new(**o)
      @component.design = self
      return @component
    end

    # Creates an instance of the component's loader (turbo-frame components only)
    # @param data [Hash] the hash of component options to be passed to the component's :new method
    # @return an instance of the component's loader
    def loader(**data)
      if(!data[:css_id])
        data[:css_id] = self.options[:css_id]
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
      o = options_data.symbolize_keys
      if(!!o[:slots] && selection == :slots)
        return o[:slots]
      elsif(!!o[:slots])
        @slots = o[:slots]
        o.delete(:slots)
      end
      if(!!o[:records])
        o[:records].map!{|f| f.to_sym }
      end
      if(!!o[:fields])
        o[:fields].map!{|f| f.to_sym }
      end
      if(!!o[:optional_fields])
        o[:optional_fields].map!{|f| f.to_sym }
      end

      return o
    end

    # Serializes hash into design's options column
    # @param data [Hash] the options data to be stored
    # @return [Hash] the data passed in
    def options=(data)
      self.options_data = data.stringify_keys
    end

    # Serializes hash into design's user option defaults
    # @param data [Hash] the options data to be stored
    # @return [Hash] the data passed in
    def settings=(data)
      self.settings_data = data.stringify_keys
    end

    # Returns design's user option defaults
    # @return [Hash] the design's user option defaults
    def settings
      self.settings_data.symbolize_keys
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
      if(!!user && user.component_options(config_key) == {})
          user.set_component_options(config_key,settings)
          user.save
          return settings
      elsif(!!user)
          return user.component_options(config_key)
      else
        return settings
      end
    end

    # If @user is set, stores the given data as
    # the user's settings for this design.
    def user_options=(data)
      if(!!user)
        user.set_component_options(config_key, data)
        user.save
      end
    end

    def defaults
      return defaults_data.symbolize_keys
    end

    def defaults=(data)
      self.defaults_data = data.stringify_keys
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
