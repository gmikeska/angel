class ViewsGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def create_views_directory
    copy_file "show.html.erb", "app/views/angel/#{file_name}.html.erb"
  end
end
