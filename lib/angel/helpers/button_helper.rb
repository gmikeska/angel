module Angel
  module ButtonHelper
    def button(link, **args)
      if(args[:class].nil?)
        args[:class] = 'btn btn-sm btn-primary'
      else
        args[:class] = "btn btn-sm #{args[:class]}"
      end

      if(!args[:content])
        content = %Q(
          View
        ).html_safe
      else
        content = %Q(
          #{content}
          #{args[:content]}
        ).html_safe
        args.delete(:content)
      end

      if(args[:icon].present?)
        content = %Q(<span class="bi bi-#{args[:icon]}" aria-hidden="true"></span>).html_safe
        args.delete(:icon)
      end

      args[:role] = "button"
      if(args[:tag].present?)
        tag_name = args[:tag]
        args.delete(:tag)
        tag.send(tag_name,content, **args)
      else
        link_to content, link, **args
      end
    end
    def view_button(link, **args)
      button(link, **args)
    end
    def back_button(link, **args)
      if(args[:class].nil?)
        args[:class] = 'btn btn-sm btn-secondary'
      end
      link_to '◀ Back',link, **args
    end
    def danger_button(link, **args)
      if(args[:class].nil?)
        args[:class] = 'btn btn-sm btn-danger'
      else
        args[:class] = "btn btn-sm btn-danger #{args[:class]}"

      end
      if(!args[:content].present?)
        args[:content] = "Delete"
      end
      button(link, **args)
    end

    def delete_button(link, **args)
      if(args[:class].nil?)
        args[:class] = ''
      else
        args[:class] = "bi bi-x-lg #{args[:class]}"
      end
      !!args[:data] || args[:data] = {}
      args[:data]["method"] = "delete"
      danger_button(link, **args)
    end

    def edit_button(link, **args)
      if(args[:class].nil?)
        args[:class] = 'btn btn-sm btn-secondary'
      end
      if(!args[:content].present?)
        args[:content] = "Edit"
      end
      button(link, **args)
    end

    def button_group(buttons,**args)
      if(!buttons.is_a? Array)
        buttons = [buttons]
      end
      if(args[:class].nil?)
        args[:class] = "btn-group"
      else
        args[:class] = "#{args[:class]} btn-group"
      end

      if(args[:aria_label].nil?)
        @aria_label = "button group"
      else
        @aria_label = args[:aria_label]
      end

      %Q(<div class="#{args[:class]}" role="group" aria-label="#{@aria_label}">
        #{buttons.join('')}
      </div>).html_safe
    end

    def toolbar(buttons,**args)
      if(!buttons.is_a? Array)
        buttons = [buttons]
      end
      if(args[:class].nil?)
        args[:class] = "btn-toolbar border"
      else
        args[:class] = "#{args[:class]} btn-toolbar border"
      end

      if(args[:style].nil?)
        @style = "width:100%;"
      elsif(!args[:style].include?("width:"))
        @style = %Q(#{args[:style]}
        width:100%;)
      end

      if(args[:aria_label].nil?)
        @aria_label = "toolbar"
      else
        @aria_label = args[:aria_label]
      end

      %Q(<div class="#{args[:class]}" role="toolbar" aria-label="#{@aria_label}" style="#{@style}">
        #{buttons.join('')}
      </div>).html_safe
    end
  end
end
