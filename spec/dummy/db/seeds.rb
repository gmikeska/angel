require 'faker'
require 'view_component'
puts "SEEDING TEST DB"


user_index = Page.create(action:"index",controller:"users")
user_index.save
user_index_table_column_defaults = {
hide_name:false,
hide_email:false,
hide_articles_count:false
}
# binding.pry
user_index_table = Design.find_or_initialize_by(name:"users_table")
if(!user_index_table.configured?)
    user_index_table.component_name = "Table"
    user_index_table.options = {
      records:[],
      css_id:"users_table",
      fields:user_index_table_column_defaults.keys.map{|n| n.to_s.match(/hide_(\w*)/)[1]},
      responsive:"md",
      optional_fields:["client_name", "edit", "delete"],
      show:true,
      edit:true,
      delete:true
    }

  user_index_table.settings = {
    hidden_fields:{
      type:"Group(check_box)",
      title:"Field Visibility",
      value: user_index_table_column_defaults
    }
  }
  user_index_table.save
  user_index_table.query = ["User", "all"]
  user_index_table.save
  user_index.add_design(user_index_table)
end
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

articles_index_table = articles_index.designs.find_or_initialize_by(name:"articles_table")
if(!articles_index_table.configured?)
    articles_index_table.component_name = "Table"
    articles_index_table.options = {
      records:[],
      css_id:"articles_table",
      fields:articles_index_table_column_defaults.keys.map{|n| n.to_s.match(/hide_(\w*)/)[1]},
      responsive:"md",
      optional_fields:["edit", "delete"],
      show:true,
      edit:true,
      delete:true
    }
    articles_index_table.settings = {
      hidden_fields:{
        type:"Group(check_box)",
        title:"Field Visibility",
        value: articles_index_table_column_defaults
      }
    }
  articles_index_table.save
  articles_index_table.settings = {
    hidden_fields:{
      type:"Group(check_box)",
      title:"Field Visibility",
      value: articles_index_table_column_defaults
    }
  }
  articles_index_table.save
  articles_index_table.query = ["Article", "all"]
  articles_index_table.save
end


# require "pry"; binding.pry
5.times do
  user_name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
  u = User.create(name:user_name, email:"#{user_name}@example.com")
  u.save
  a = Article.create(title:Faker::Company.catch_phrase, author:u, body:Faker::Quote.matz)
  a.save
end
