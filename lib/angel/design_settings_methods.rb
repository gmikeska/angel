module Angel
  module DesignSettingsMethods
    extend ActiveSupport::Concern
    included do
      cattr_accessor :design_serializer, :design_deserializer
      def self.save_design_settings(method_name=nil, &block)
        # Example:
        # save_design_settings :save_design
        return @@design_serializer = method_name.to_sym if(!!method_name)
      end

      def self.load_design_settings(method_name=nil, &block)
        # Example:
        # load_design_settings :load_design
        return @@design_deserializer = method_name.to_sym if(!!method_name)
      end
    end
    def design_serializer
      return self.class.design_serializer
    end
    def design_deserializer
      return self.class.design_deserializer
    end
    def design_settings(design_key=nil)
      if(!!design_deserializer && design_deserializer.is_a?(Symbol) )
        return self.send(design_deserializer, design_key)
      elsif(!!design_deserializer && design_deserializer.is_a?(Proc) )
        return design_deserializer.call(design_key)
      else
        raise Exception.new %Q(NotImplementedError - DesignSettingsMethods#design_settings is abstract.
          Please implement 'design_settings(design_key=nil)' in #{self.class.name} (design_settings should return a data hash comprised of keys and values saved with 'set_design_settings')
  (or set default accessors using callback setter :load_design_settings))
      end

    end
    def set_design_settings(design_key, data)
      if(!!design_serializer && design_serializer.is_a?(Symbol) )
        return self.send(design_serializer, design_key, data)
      elsif(!!design_serializer && design_serializer.is_a?(Proc) )
        return design_serializer.call(design_key, data)
      else
        raise Exception.new %Q(NotImplementedError - DesignSettingsMethods#set_design_settings is abstract.
          Please implement 'set_design_settings(design_key, data)' in #{self.class.name} (where design_key will be a string pointing to the design, and data is a hash of design settings.)
  (or set default accessors using callback setter :save_design_settings))
      end
    end

    def settings_scope_name
      return self.class.name
    end


  end
end
