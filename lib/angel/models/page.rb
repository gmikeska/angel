module Angel
  class Page < Base

    serialize :settings_data
    has_many :designs

    before_save do |p|
      p.settings_data = {renders:[]} if(!p.settings_data)
    end

    def action_settings_root
      if(self.action != nil)
        return Page.find_by(action:self.action, controller:nil)
      else
        return self
      end
    end

    def get_url
      if(action == "index")
        Rails.application.routes.url_helpers.send("#{self.controller}_path")
      end
    end

    def controller_settings_root
      if(self.controller != nil)
        return Page.find_by(controller:self.controller, action:nil)
      else
        return self
      end
    end

    def settings # merge this entry's settings with 'controller-wide' settings, stored in action:""
      data = settings_data.symbolize_keys #.merge(action_settings_root).merge()
      if(self.action == nil || self.controller == nil)
        return settings_data
      else
        controller_root_settings = controller_settings_root.try(:settings)#.map! do |k,v|
        if(controller_root_settings != self)
          #   if(!!v && v.is_a?(Array))
          #     v = v.map do |val|
          #       if(val.match(/\{(?<field_name>.*)\}/))
          #         field_name = val.match(/\{(?<field_name>.*)\}/)["field_name"]
          #         require 'pry';binding.pry
          #         val = val.gsub("{#{field_name}}",self[field_name])
          #       end
          #     end
          #   else
          #     if(!!v && v.match(/\{(?<field_name>.*)\}/))
          #       field_name = v.match(/\{(?<field_name>.*)\}/)["field_name"]
          #       v = v.gsub("{#{field_name}}",self[field_name])
          #     end
          #   end
          # end

          data = data.merge(controller_root_settings) if(!!controller_root_settings)
        end
        if(action_settings_root != self)
          action_root_settings = action_settings_root.try(:settings)#.map! do |k,v|
          if(!!action_root_settings && !!action_root_settings["renders"])
            action_root_settings["renders"][0] = action_root_settings["renders"][0].gsub("{controller}",self[:controller])
            data = data.merge(action_root_settings)
          end
        end
        return data
      end
    end
  end
end
