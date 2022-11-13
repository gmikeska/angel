module Angel
  module Components
    class SiteNavComponent < CustomizableComponent
      renders_many :items

      def initialize(**args)
        if(!!args[:items] && args[:items].is_a?(Array))
          args[:items].each do |i|
            self.with_item do
              if(!!i[:items])
                res = self.dropdown_menu(i[:title], i[:items])
              end
              res = self.item(i[:title],i[:url])
            end
          end
        end
        functional_class_list = %I[navbar navbar-expand-md navbar-light]
        if(!args[:css_class])
          args[:css_class] = [].concat(functional_class_list.map(&:to_s)).uniq.join(" ")
        else
          args[:css_class] = args[:css_class].concat(functional_class_list.map(&:to_s)).uniq.join(" ")
        end
        super(**args)
        if(!args[:css_id])
          @css_id = "mainNav"
        else
          @css_id = args[:css_id]
        end
      end

      def item(title, url)
        %Q(<li class="nav-item" id="nav-#{title.parameterize}">
          #{item_link(title, url)}
        </li>).html_safe
      end

      def item_link(title,url)
        %Q(<a class="nav-link" href="#{url}">#{title}</a>).html_safe
      end

      def dropdown_menu(title, items)
        output = %Q(<li class='nav-item dropdown'>
              <a class="nav-link dropdown-toggle" href="#" id="#{title.parameterize}Dropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
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
      def self.defaults
        return super.merge({items:[], css_id:"mainNavContent",css_class:["navbar", "navbar-expand-md", "navbar-light"]})
      end
      def self.params
        return super.concat([:items])
      end
    end
  end
end
