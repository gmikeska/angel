module Angel
  module Components
    class TableComponent < CustomizableComponent
      renders_one :header
      renders_one :body
      renders_many :records, Angel::Components::RecordComponent
      renders_one :placeholder
      attr_reader :fields, :optional_fields,:show,:edit,:delete, :records
      # include TagHelper
      # include Rails.application.routes.named_routes.path_helpers_module
      # include Rails.application.routes.named_routes.url_helpers_module
      # include ApplicationHelper

      def initialize(**args)
        @records = args[:records] || []
        if(!args[:css_id] && self.records.length > 0)
          args[:css_id] = self.records.first.class.name.downcase.pluralize+"-table"
        elsif(!args[:css_id] && self.records.length == 0)
          args[:css_id] = "empty-table"
        end
        if(args[:fields].nil? && @records.present? && @records.count > 0)
          @fields = @records.first.class.columns.collect{|c| c.name.to_sym}
        else
          @fields = args[:fields]
        end
        if(!!args[:optional_fields])
          @optional_fields = args[:optional_fields]
        end
        if(!!args[:stretch_record_link])
          @stretch_record_link = args[:stretch_record_link]
          @show = false
        else
          @show = args[:show]
        end
        @edit = args[:edit]
        @delete = args[:delete]
        if(!!args[:responsive] && args[:responsive] == true)
          args[:css_class] = "table table-sm"
          @responsive = "table-responsive"
        elsif(!!args[:responsive] && args[:responsive].is_a?(String))
          args[:css_class] = "table table-sm"
          @responsive = "table-responsive-#{args[:responsive]}"
        end
        if(!!args[:pagination_count] && args[:pagination_count] > 0)
          @pagination_count = args[:pagination_count]
          if(!!args[:page_number])
            @page_number = args[:page_number]
          else
            @page_number = 0
          end
        end
        super(**args)
      end
      def loader(source)
        return %Q(<turbo-frame src="#{source}" id="#{css_id}"></turbo-frame>).html_safe
      end
      def table_header(**args)
        if(!args[:fields])
          args[:fields] = @fields
        end
        if(!args[:show])
          args[:show] = @show
        end
        if(!args[:edit])
          args[:edit] = @edit
        end
        if(!args[:delete])
          args[:delete] = @delete
        end
        linkSpan = 0
        outstr = %Q(<thead>
          <tr>)
          args[:fields].each do |field|
            if(!!@optional_fields && @optional_fields.include?(field))
              outstr = outstr + "<th class='d-none d-md-table-cell'>#{field.to_s.titleize}</th>"
            else
              outstr = outstr + "<th>#{field.to_s.titleize}</th>"
            end
          end
          if(args[:show])
            linkSpan = linkSpan+1
          end
          if(args[:edit])
            linkSpan = linkSpan+1
          end
          if(args[:delete])
            linkSpan = linkSpan+1
          end
          if(linkSpan > 0)
            outstr = outstr + %Q(<th colspan="#{linkSpan}"></th>)
          end
          outstr = outstr + %Q(</tr>
        </thead>)
        return outstr.html_safe
      end

      def paginated?
        return (!!@records && @records.length > 0 && (!!@pagination_count && @pagination_count > 0) && @records.length > @pagination_count)
      end
      def page_select(**opts, &block)
        if(paginated?)

          if(!!opts[:path_root])
            @path_root = opts[:path_root]
            opts.delete(:path_root)
          else
            @path_root = ""
          end
          if(!opts[:active_page_class])
            opts[:active_page_class] = " active"
          end
          if(!opts[:inactive_page_class])
            opts[:inactive_page_class] = ""
          end
          if(!opts[:wrapper_id])
            opts[:wrapper_id] = "table-page-control"
          end
          if(!opts[:wrapper_class])
            opts[:wrapper_class] = "pagination"
          end
          content = (0...number_of_pages).to_a.map do |page|
            id_string = " id='page-#{page}'"
            if(page == @page_number)
              class_string = " class='page-item #{opts[:active_page_class]}'"
            else
              class_string = " class='page-item #{opts[:inactive_page_class]}'"
            end
            if((@page_number - page).abs >2 )
              class_string = class_string.gsub('page-item','page-item d-md-inline d-none')
            end
            link = @path_root+"/paginate/#{@pagination_count}/page/#{page}"
            "<li #{class_string}><a class='page-link' id='#{id_string}' href='#{link}'>#{page+1}</a></li>".html_safe
          end
          if(@page_number > 0)
            link = @path_root+"/paginate/#{@pagination_count}/page/#{@page_number-1}"
            class_str = " "
          else
            link = "#"
            class_str = " disabled"
          end
          prev_button = "<li id='page-previous' class='page-item page-nav #{class_str}'><a class='page-link' href='#{link}'> < Prev </a></li>".html_safe
          if(@page_number < number_of_pages-1)
            link = @path_root+"/paginate/#{@pagination_count}/page/#{@page_number+1}"
            class_str = " "
          else
            link = "#"
            class_str = " disabled"
          end
          next_button = "<li id='page-next' class='page-item page-nav #{class_str}'><a class='page-link' href='#{link}'> Next > </a></li>".html_safe
          content = content.join("").html_safe
          content = %(
            #{prev_button}
            #{content}
            #{next_button}
          ).html_safe

          opts[:class] = opts[:wrapper_class]
          opts.delete(:wrapper_class)
          opts[:id] = opts[:wrapper_id]
          opts.delete(:wrapper_id)

          opts.delete(:active_page_class)
          opts.delete(:inactive_page_class)
          return tag.ul(content, **opts).html_safe
        end
      end
      def table_body(**args, &block)
        content = records_for(@page_number).map(&block)

          return tag.tbody(content.join('').html_safe, **args).html_safe
      end
      def number_of_pages
        if(paginated?)
          page_count = @records.count/@pagination_count
          if((@records.count % @pagination_count) > 0)
            page_count = page_count+1
          end
          return page_count
        else
          return 1
        end
      end

      def records_for(page_number=0)
        if(!page_number)
          page_number = 0
        end
        if(paginated?)
          return @records[starting_index(page_number),@pagination_count]
        else
          return @records
        end
      end

      def starting_index(number=0)
        if(paginated?)
          return(number*@pagination_count)
        else
          return 0
        end
      end

      def ending_index(page_number=0)
        if(paginated?)
          return starting_index(page_number)+(@pagination_count-1)
        else
          return 0
        end
      end

      def colspan
        length = @fields.length
        if(@show)
          length = length+1
        end
        if(@edit)
          length = length+1
        end
        if(@delete)
          length = length+1
        end
        return length
      end
      def self.params
        return super().concat([:records, :fields, :show, :edit, :delete])
      end
    end
  end
end
