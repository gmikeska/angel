require "view_component"
require "angel/helpers/button_helper"

module Angel
  module Components
    class CustomizableComponent < ViewComponent::Base

      attr_accessor :args, :semantic_classes, :data_controller,:design
      include TagHelper
      include Angel::ButtonHelper


      def initialize(**args)
        @args = args
        if(!!args[:semantic_classes])
          @semantic_classes = args[:semantic_classes]
          args.delete(:semantic_classes)
        end
        if(!!args[:edit_path])
          @edit_path = args[:edit_path]
        end
        if(!!@args[:class])
          if(@args[:class].is_a? String)
            @args[:class] = @args[:class].split(" ")
          end
        else
          @args[:class] = []
        end

      end

      def data_controller=(controller_name)
        @data_controller = controller_name
        set_data("controller", controller_name)
      end

      def data_target(tgt_name)
        "data-#{data_controller}-target=#{tgt_name}".html_safe
      end


      def css_id
        return @args[:id]
      end

      def css_id_for_tag(suffix=nil)
        if(!!suffix)
          output = "id='#{css_id}-#{suffix}'"
        else
          output = "id='#{css_id}'"
        end
        return output.html_safe
      end

      def css_class_for_tag
        cssclass = css_class
        if(!!cssclass && cssclass != "[]" && cssclass != [])
          return %Q(class='#{cssclass}').html_safe
        else
          return ""
        end
      end

      def css_class
        if(!!self.semantic_classes)
          return semantic_classes.map(&:lstrip).map(&:rstrip).concat(@args[:class].split(" ").flatten.map(&:lstrip).map(&:rstrip)).uniq.join(" ")
        else
          return @args[:class].join(" ").lstrip.rstrip
        end
      end

      def add_class(new_class)
        new_class = new_class.split(" ").flatten.map(&:lstrip).map(&:rstrip) if(!new_class.is_a? Array)
        class_list = @args[:class].split(" ").flatten.map(&:lstrip).map(&:lstrip)
        themed_classes = new_class.select{|c| ["light","dark"].include?((c.split('-')[1]).lstrip.rstrip ) }
        opposite_themes = themed_classes.map do |tc|
          root = tc.split('-')[0].lstrip.rstrip;
          theme = tc.split('-')[1].lstrip.rstrip
          opp = (["light","dark"] -[theme]).first
          "#{root}-#{opp}"
        end
        class_list = class_list - opposite_themes if(opposite_themes.intersection(class_list).any?)

        class_list = class_list.concat(new_class).uniq
        # if(!class_list.include?(new_class))
        #   class_list << new_class
        # end
        @args[:class] = class_list.join(" ")
      end

      def set_data(key,value)
        @args[:data][key] = value
      end

      def set_id(id)
        @id = id
      end

      def loader(source, **args)
        return %Q(<turbo-frame data-turbo-frame="#{self.css_id}" src="#{source}" class="#{self.css_class}" id="#{self.css_id}"></turbo-frame>).html_safe
      end

      def set_style(style_string)
        @args[:style] = style_string
      end

      def tag_args
        t_args = {}
        t_args[:class] = css_class || ""
        t_args[:id] = css_id || ""
        t_args[:style] = style || ""
        t_args[:data] = data || {}

        return t_args
      end

      def wrap(*args)
        value = nil
        buffer = with_output_buffer { value = yield(*args).html_safe }
        content = buffer.to_s
        return content_tag(@args[:tag_name].to_sym,"\n#{content.to_s.html_safe}\n".html_safe,**tag_args).html_safe
      end

      def create_link_url(link_reference)
        if(Page.first.is_pointer?(link_reference))
          return Page.resolve_pointer(link_reference).url
        else
          return link_reference
        end
      end

      def settings_button(**args)
        if(!args[:icon])
          args[:icon] = "three-dots"
        elsif(args[:icon] == :vertical)
          args[:icon] = "three-dots-vertical"
        end
        if(!args[:content])
          args[:content] = args[:icon]
        end
        args[:data] = {toggle:"dropdown"}
        args[:style] = "background-color:transparent;color: #212529; border-color:transparent; position:absolute; right: 0.4%;"
        args[:id] = "#{self.css_id}-settings"
        args[:tag] = "button"
        # <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        # Dropdown button
        # </button>
        # <div class="dropdown-menu" aria-labelledby="#{self.css_id}-settings" style="display: block; position: absolute; right: 0.4%; margin-top: 3%;">
        %Q(
          <div class="dropdown">
            #{button("", **args)}
            <div class="dropdown-menu" aria-labelledby="#{self.css_id}-settings">
              <a class="dropdown-item" id="table_settings" href="#{@edit_path}" data-turbo-frame="#{self.css_id}">Table Settings</a>
            </div>
          </div>
          <script>
          $("##{self.css_id}-settings").click((e)=>{
              e.prevent_default
              $("##{self.css_id}-settings").dropdown("toggle")
            })
          </script>
        ).html_safe
      end

      def self.count
        ObjectSpace.each_object(self).count
      end

      def self.editor_fields(**args)
        data = self.design.settings
        if(!options["_user_options"])
          options["_user_options"] = data
        end
        self.params.map do |k,v|
           if(v=="String")
             data[k] = {type:"text_field"}
           elsif(v == "Hash(Boolean)")
             data[k] = {type:"Group(check_box)"}
           elsif(v == "Boolean")
             data[k] = {type:"check_box"}
           elsif(v == "Array(String)" && !args[:enum_type] || args[:enum_type] == :select)
             data[k] = {type:"select"}
           elsif(v == "Array(String)" && !args[:enum_type] || args[:enum_type] == :radio_group)
             data[k] = {type:"Group(radio_button)"}
           elsif(v == "Array(Boolean)")
             data[k] = {type:"Group(check_box)"}
           elsif(v == "Enum" && !args[:enum_type] || args[:enum_type] == :select)
             data[k] = {type:"select"}
           elsif(v == "Enum" && !!args[:enum_type] && args[:enum_type] == :radio_group)
             data[k] = {type:"Group(check_box)"}
           end
           return {css_class:{type:"text_field"}, css_id:{type:"text_field"} }
           # return {css_class:{type:"text_field"}, css_id:{type:"text_field"},css_style:{type:"text_field"} }
        end
      end

      def editor_fields
        begin
        result = self.class.editor_fields
        result.keys.each{|k| result[k][:value] = self.send(k) }
        return result

        rescue => e
          binding.pry
        end
      end

      def method_missing(method_name, assignment=nil)
        method_name = method_name.to_s
        if(method_name.ends_with?("="))
          method_name = method_name.match(/(?<name>\w*)=/)[:name]
          return @args[method_name.to_sym] = assignment
        else
          if(!!@args[method_name])
            return @args[method_name]
          end
        end
      end

      def self.defaults
        return @design.defaults
      end

      def self.params
        return {css_class:"String", css_id:"String"}
      end
    end
  end
end
