require "view_component"
require "angel/helpers/button_helper"

module Angel
  module Components
    class CustomizableComponent < ViewComponent::Base
      attr_reader :css_class, :css_id, :style, :src
      include TagHelper
      include ApplicationHelper
      include Angel::ButtonHelper
      include Rails.application.routes.named_routes.path_helpers_module
      include Rails.application.routes.named_routes.url_helpers_module

      def initialize(**args)
        if(!!args[:css_class])
          @css_class = args[:css_class]
        else
          @css_class = ""
        end

        if(!!args[:css_id])
          @css_id = args[:css_id]
        else
          @css_id = ""
        end

        if(!!args[:style])
          @style = args[:style]
        else
          @style = ""
        end

        if(!!args[:src])
          @src = args[:src]
        else
          @src = ""
        end

        if(!!args[:tag_name])
          @tag_name = args[:tag_name]
        else
          @tag_name = :"turbo-frame"
        end
        if(!!args[:data])
          @data = args[:data]
        else
          @data = {}
        end
      end

      def add_class(new_class)
        @css_class = "#{@css_class} #{new_class}"
      end

      def set_data(key,value)
        @data[key] = value
      end

      def set_id(id)
        @id = id
      end

      def loader(source)
        return %Q(<turbo-frame src="#{source}" class="#{self.css_class}" id="#{self.css_id}"></turbo-frame>).html_safe
      end

      def set_style(style_string)
        @style = style_string
      end

      def tag_args
        args = {}
        args[:class] = css_class || ""
        args[:id] = css_id || ""
        args[:style] = style || ""
        args[:data] = data || {}

        return args
      end

      def wrap(*args)
        value = nil
        buffer = with_output_buffer { value = yield(*args).html_safe }
        content = buffer.to_s
        return content_tag(@tag_name.to_sym,"\n#{content.to_s.html_safe}\n".html_safe,**tag_args).html_safe
      end

      def create_link_url(link_reference)
        if(Page.first.is_pointer?(link_reference))
          return Page.resolve_pointer(link_reference).url
        else
          return link_reference
        end
      end

      def self.count
        ObjectSpace.each_object(self).count
      end

      def self.defaults
        return {}
      end

      def self.params
        return [:css_class,:id]
      end
    end
  end
end
