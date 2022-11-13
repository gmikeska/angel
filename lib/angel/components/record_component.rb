module Angel
  module Components
    class RecordComponent < CustomizableComponent
      def initialize(**args)
        @record = args[:record]

        if(args[:fields].nil? && @records.present? && @records.count > 0)
          @fields = @record.class.columns.collect{|c| c.name.to_sym}
        else
          @fields = args[:fields]
        end
        if(!!args[:optional_fields])
          @optional_fields = args[:optional_fields]
        else
          @optional_fields = []
        end
        if(!!args[:stretch_record_link])
          @stretch_record_link = args[:stretch_record_link]
          @link_index = 0
          @show = false
        else
          @show = args[:show]
        end
        @edit = args[:edit]
        @delete = args[:delete]
      end

      def header
        linkSpan = 0
        outstr = %Q(<thead>
          <tr>)
          @fields.each do |field|
            if(@optional_fields.include? field)
              outstr = outstr + "<th>#{field.to_s.titleize}</th>"
            else
              outstr = outstr + "<th class='d-none d-md-table-cell'>#{field.to_s.titleize}</th>"
            end
          end
          if(@show)
            linkSpan = linkSpan+1
          end
          if(@edit)
            linkSpan = linkSpan+1
          end
          if(@delete)
            linkSpan = linkSpan+1
          end
          if(linkSpan > 0)
            outstr = outstr + %Q(<th colspan="#{linkSpan}"></th>)
          end
          outstr = outstr + %Q(</tr>
        </thead>)
        return outstr.html_safe
      end

      def render_cell_content(fieldName)
        if(fieldName.is_a? String)
          return "#{fieldName}".html_safe
        elsif(@record.respond_to? fieldName)
          return "#{@record.send(fieldName)}".html_safe
        elsif(fieldName.to_s.include? "_" )
          methods = fieldName.to_s.split("_"); cursor = @record
          methods.each do |m|
            cursor = cursor.send(m)
          end
          return "#{cursor}".html_safe
        end
      end

      def render_cell_for(fieldName, class_string=" ")
        return "<td #{class_string}>#{render_cell_content(fieldName)}</td>".html_safe
      end

      def render_link_cell_for(fieldName, class_string=" ")
        cell_content = render_cell_for(link_to(render_cell_content(fieldName), @record, class:"stretched-link text-decoration-none"), class_string)
        return cell_content
      end
    end
  end
end
