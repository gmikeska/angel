module Angel
  class Design < Base
    serialize :options_data
    belongs_to :page, optional: true

    def component(**args)
      (self.component_name.classify+"Component").constantize.new(**options.merge(args))
    end

    def loader(data)
      if(data[:path])
        path = data[:path]
        data.delete(:path)
      else
        path = "/designs/#{self.id}"
        if(!!self.page)
          path = "/pages/#{self.page.id}#{path}"
        end
      end

      self.component(**data).loader(path).html_safe
    end

    def params
      component.class.params
    end

    def options
      o = options_data.symbolize_keys
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

    def options=(data)
      self.options_data = data.stringify_keys
    end

  end
end
