module Angel
  module Components
    class SiteNavComponent < CustomizableComponent
      renders_many :items

      def initialize(**args)
        if(!!args[:items] && args[:items].is_a?(Array))
          args[:items].each do |i|
            if(i[:hidden] != true)
              self.with_item do
                if(!!i[:items])
                  res = self.dropdown_menu(i[:title], i[:items])
                end
                res = self.item(i[:title],i[:url])
              end
            end
          end
        end
        css_classlist = ""
        if(!!args[:css_class])
          css_classlist = args[:css_class]
          args.delete(:css_class)
        end
        super(**args)
        self.semantic_classes = %I[navbar navbar-expand-lg].map(&:to_s)
        self.add_class("navbar-light")
        if(css_classlist != "")
          add_class(css_classlist)
        end
      end

      def item(title, url)
        if(!!title && !!url)
          %Q(<li class="nav-item" id="nav-#{title.parameterize}">
            #{item_link(title, url)}
          </li>).html_safe
        end
      end

      def item_link(title,url)
        if(!!title && !!url)
          %Q(<a class="nav-link" target="_top" href="#{url}">#{title}</a>).html_safe
        end

      end

      def dropdown_menu(title, items)
        if(!!title && !!items)
          output = %Q(<li class='nav-item dropdown'>
                <a class="nav-link dropdown-toggle" target="_top" href="#" id="#{title.parameterize}Dropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                  #{title}
                </a>
                <ul class="dropdown-menu" id="#{title.parameterize}DropdownMenu" aria-labelledby="#{title.parameterize}Dropdown">)

          items.each do |item|
            if(item == :divider)
              output = output+"\n"+'<li><hr class="dropdown-divider"></li>'
            else
              output = output+"\n"+'<li><a id="'+item[:title].parameterize+'" class="dropdown-item" href="'+item[:url]+'">'+item[:title]+'</a></li>'
            end
          end

          output = output + "\n" + %Q(</ul>
            </li>)
          return output.html_safe
        end

      end
      def self.defaults
        return super.merge({items:[], css_id:"mainNavContent",class:["navbar", "navbar-expand-md", "navbar-light"]})
      end
      def self.params
        return super.merge({items:"Array(String)"})
      end
    end
  end
end
