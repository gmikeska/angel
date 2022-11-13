require 'faker'
require 'view_component'
puts "SEEDING TEST DB"
view_component_opts = ActiveSupport::OrderedOptions.new
view_component_opts.view_component_path = "app/components"
ViewComponent::Base.config = view_component_opts
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
user_index_table = user_index.designs.create({
  component_name:"Table"
})
user_index_table.options = {
  records:[],
  fields:["name", "email", "articles_count"],
  responsive:"md",
  optional_fields:["client_name", "edit", "delete"],
  show:true,
  edit:true,
  delete:true
}
user_index_table.save
user_index.save
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
