require "faker"
FactoryBot.define do
  factory :design do
    name { "users_table" }
    component_name { "table" }
    options_data { "" }

    after :create do |design|
      design.options = {
        records:[],
        css_id:"users_table",
        fields:{
          hide_name:false,
          hide_email:false,
          hide_articles_count:false
          }.keys.map{|n| n.to_s.match(/hide_(\w*)/)[1]},
        responsive:"md",
        optional_fields:["email","edit", "delete"],
        show:true,
        edit:true,
        delete:true
      }
      design.set_scope_defaults(:user,{
        hidden_fields:{
          type:"Group(check_box)",
          title:"Field Visibility",
          value: {
            hide_name:false,
            hide_email:false,
            hide_articles_count:false
          }
        }
      })
    end
  end
end
