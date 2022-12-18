module Angel
  module FormHelper
    def field_for(name,design,data,form)
      result = []
      opts = data[:options] || {}

      if(data[:type].match?(/Group/))
        if(!!data[:title])
          result << "<h3>#{data[:title]} for #{design.name.titleize}</h3>"
        end
        if(!!data[:type].match?(/check_box/))
          result << form.check_box(k, opts)+"<br>"
        end
        if(!!data[:type].match?(/radio_button/))
          result << form.radio_button(k, opts)+"<br>"
        end
        if(!!data[:type].match?(/text_field/))
          result << form.text_field(k, opts)+"<br>"
        end
        if(!!data[:type].match?(/select/))
          result << form.select(k,options_for_select(data[:options]), opts)+"<br>"
        end
      else
        if(!!data[:type].match?(/check_box/))
          result << form.check_box(k, opts)
        end
        if(!!data[:type].match?(/radio_button/))
          result << form.radio_button(k, opts)
        end
        if(!!data[:type].match?(/text_field/))
          result << form.text_field(k, opts)
        end
        if(!!data[:type].match?(/select/))
          result << form.select(k,options_for_select(data[:options]), opts)
        end
      end
      return result.join("\n")
    end
  end
end
