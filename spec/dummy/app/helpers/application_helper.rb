module ApplicationHelper
  def field_for(name,design,data,form_builder)
    result = []
    opts = data[:options] || {}

    form_builder.fields_for :user_options do |form|
      if(data[:type].match?(/Group/))
        if(!!data[:title])
          result << "<h3>#{data[:title]} for #{design.name.titleize}</h3>"
        end
        form.fields_for name do |group_form|
          result << %Q(<div class="input-group input-group-sm mb-3">)
          data[:value].each do |k, v|
            if(data[:type].match?(/check_box/))
              opts = {}
              opts[:checked] = v
              # opts[:label] = k.titleize
              result << group_form.check_box(k, opts)
            end
            if(data[:type].match?(/radio_button/))
              opts = {}
              opts[:selected] = v
              # opts[:label] = k.titleize
              result << group_form.radio_button(k, opts)
            end
            if(data[:type].match?(/text_field/))
              opts = {}
              opts[:value] = v
              # opts[:label] = k.titleize
              result << group_form.text_field(k, opts)
            end
            if(data[:type].match?(/select/))
              opts[:selected] = v
              # opts[:label] = k.titleize
              result << group_form.select(k,options_for_select(v[:options]), opts)
            end
          end
        end
        result << %Q(</div>)
      else
        if(data[:type].match?(/check_box/))
          opts = {}
          opts[:checked] = data[:value]
          result << form_builder.check_box(name, opts)
        end
        if(data[:type].match?(/radio_button/))
          opts = {}
          opts[:selected] = data[:value]
          result << form_builder.radio_button(name, opts)
        end
        if(data[:type].match?(/text_field/))
          opts = {}
          opts[:value] = data[:value]
          result << form_builder.text_field(name, opts)
        end
        if(data[:type].match?(/select/))
          opts = {}
          opts[:selected] = data[:value]
          result << form_builder.select(name,options_for_select(data[:options]), opts)
        end
      end
    end
    return result.join("\n").html_safe
  end
end
