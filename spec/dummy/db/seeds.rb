require 'faker'
require 'view_component'
puts "SEEDING TEST DB"

site_nav = Design.new({
  name:"site_nav",
  component_name:"SiteNav",
  options:{
    items:[
      {
        title:"Home",
        url:"/"
      },
      {
        title:"Users",
        url:"/users"
      },
      {
        title:"Articles",
        url:"/articles"
      }
    ]
  }
  })
site_nav.save
user_index = Page.create(action:"index",controller:"users")
user_index.save
user_index_table_column_defaults = {
hide_name:false,
hide_email:false,
hide_articles_count:false
}
# binding.pry
user_index_table = Design.create({
  name:"users_table",
  component_name:"Table",
  options:{
    records:[],
    css_id:"users_table",
    fields:user_index_table_column_defaults.keys.map{|n| n.to_s.match(/hide_(\w*)/)[1]},
    responsive:"md",
    optional_fields:["client_name", "edit", "delete"],
    show:true,
    edit:true,
    delete:true
  },
  settings:{
    hidden_fields:{
      type:"Group(check_box)",
      title:"Field Visibility",
      value:user_index_table_column_defaults
    }
  }
})

user_index.add_design(user_index_table)
# binding.pry
user_index_table.save
# binding.pry
# user_index_table = user_index.designs.create({
#   name:"users_table",
#   component_name:"FilteredTable",
#   options:{
#     records:User.all,
#     css_id:"users_table",
#     fields:["name", "email", "articles_count"],
#     responsive:"md",
#     optional_fields:["client_name", "edit", "delete"],
#     show:true,
#     edit:true,
#     delete:true
#   }
# })
# user_index_table.save
user_index_table.query = ["User", "all"]
user_index_table.save

# user_index_table.options = {
#   records:[],
#   css_id:"users_table",
#   fields:["name", "email", "articles_count"],
#   responsive:"md",
#   optional_fields:["client_name", "edit", "delete"],
#   show:true,
#   edit:true,
#   delete:true
# }

# require "pry"; binding.pry
articles_index = Page.create(action:"index",controller:"articles")
articles_index.save
articles_index_table_column_defaults = {
  hide_title:false,
  hide_author_name:false,
  hide_author_email:false
}
articles_index_table = articles_index.designs.create({
  name:"articles_table",
  component_name:"Table",
  options:{
    records:[],
    css_id:"articles_table",
    fields:articles_index_table_column_defaults.keys.map{|n| n.to_s.match(/hide_(\w*)/)[1]},
    responsive:"md",
    optional_fields:["edit", "delete"],
    show:true,
    edit:true,
    delete:true
  },
  settings:{
    hidden_fields:{
      type:"Group(check_box)",
      title:"Field Visibility",
      value: articles_index_table_column_defaults
    }
  }
})
articles_index_table.save
# articles_index_table.options = {
#   records:[],
#   css_id:"articles_table",
#   fields:["title", "author_name", "author_email"],
#   responsive:"md",
#   optional_fields:["edit", "delete"],
#   show:true,
#   edit:true,
#   delete:true
# }

# articles_index_table.user_options = {
#   hidden_fields:{
#     type:"Group(check_box)",
#     title:"Field Visibility",
#     key_list: :fields,
#
#   }
# }
# user_index_table.header_slot
articles_index_table.save
articles_index_table.query = ["Article", "all"]
articles_index_table.save
# users_controller_root = Page.create(controller:"users")
# users_controller_root.save

user_index = Page.create(action:"index", controller:"users")
# require "pry"; binding.pry
5.times do
  user_name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
  u = User.create(name:user_name, email:"#{user_name}@example.com")
  u.save
  a = Article.create(title:Faker::Company.catch_phrase, author:u, body:Faker::Quote.matz)
  a.save
end
